import Flutter
import UIKit
import LoginWithAmazon
import Foundation

struct LoginResponse: Codable {
    var user_id: String
    var accessToken: String
    var email: String
    var name: String
    var eventName: String
}

public class SwiftLwaPlugin: NSObject, AMZNLWAAuthenticationDelegate, FlutterPlugin  {
    var accessToken = ""
    var eventChannelHandler: EventChannelHandler?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftLwaPlugin()
        instance.setupChannel(registrar: registrar)
    }
    
    private func setupChannel(registrar: FlutterPluginRegistrar){
        eventChannelHandler = EventChannelHandler(
            id: "lwa.authentication",
            messenger: registrar.messenger()
        )
        let channel = FlutterMethodChannel(name: "lwa", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(self, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "signIn":
                signIn(result: result)
            case "signOut":
                signOut()
            default:
                print("Not implemented")
        }
    }


    static func userToJson(user: LoginResponse) -> [String: Any?] {
        let mapData: [String: Any?] = [
            "user_id": user.user_id,
            "accessToken": user.accessToken,
            "email": user.email,
            "name": user.name,
            "eventName": user.eventName
        ]
        return mapData
    }
    

    //override
    public func requestDidSucceed(_ apiResult: APIResult!) {
        switch (apiResult.api) {
            case API.authorizeUser:
                AMZNLWAMobileLib.getAccessToken(forScopes: ["profile"], withOverrideParams: nil, delegate: self)
            case API.getAccessToken:
                guard let LWAtoken = apiResult.result as? String else { return }
                accessToken = LWAtoken
                AMZNLWAMobileLib.getProfile(self)
            case API.getProfile:
                do {
                    var response = LoginResponse(
                        user_id: "",
                        accessToken: "",
                        email: "",
                        name: "",
                        eventName: ""
                    )
                    let userDict = (apiResult.result as! [String:String])
                    for (key, value) in userDict {
                        if(key == "user_id") {
                            response.user_id = value
                        }
                        if(key == "email") {
                            response.email = value
                        }
                        if(key == "name") {
                            response.name = value
                        }
                    }
                    response.accessToken = accessToken
                    response.eventName = "loginSuccess"
                    try self.eventChannelHandler?.success(event: jsonToString(json: response))
                } catch {
                    self.eventChannelHandler?.error(code: "loginFailure", message: error.localizedDescription)
                }
            case API.clearAuthorizationState:
                do {
                    var response = LoginResponse(
                        user_id: "",
                        accessToken: "",
                        email: "",
                        name: "",
                        eventName: "logoutSuccess"
                    )
                    try self.eventChannelHandler?.success(event: jsonToString(json: response))
                }
                catch {
                    self.eventChannelHandler?.error(code: "logoutFailure", message: error.localizedDescription)
                }
            default:
                print("unsupported")
        }
    }
    
    public func jsonToString(json: Codable) -> String {
        do {
            let jsonData = try JSONEncoder().encode(json)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
        } catch {
            self.eventChannelHandler?.error(code: "decodeFailure", message: error.localizedDescription)
            return ""
        }
    }

    //override
    public func requestDidFail(_ errorResponse: APIError!) {
        print("Error: \(errorResponse.error.message ?? "nil")")
    }
    
    public func signIn(result: FlutterResult) {
        AMZNLWAMobileLib.authorizeUser(forScopes: ["profile"], delegate: self)
        result("true")
    }

    public func signOut() {
        AMZNAuthorizationManager.shared().signOut({ (error) in
          if((error) != nil) {
              self.eventChannelHandler?.error(code: "logoutError", message: error?.localizedDescription)
              print("There was an error signing out")
          }
          AMZNLWAMobileLib.clearAuthorizationState(self)
        })
    }
}

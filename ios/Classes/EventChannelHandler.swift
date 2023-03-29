import Flutter
import Foundation

class EventChannelHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public init(id: String, messenger: FlutterBinaryMessenger) {
          super.init()
          let eventChannel = FlutterEventChannel(name: id, binaryMessenger: messenger)
          eventChannel.setStreamHandler(self)
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
       eventSink = nil
       return nil
    }
    
    public func success(event: Any?) throws {
        if eventSink != nil {
            eventSink?(event)
        }
    }
    
    public func error(code: String, message: String?, details: Any? = nil) {
        if eventSink != nil {
            eventSink?(FlutterError(code: code, message: message, details: details))
        }
    }
}

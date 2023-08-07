package io.firedance.lwa

import android.annotation.SuppressLint
import android.app.Activity
import android.os.Build
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import com.amazon.identity.auth.device.AuthError
import com.amazon.identity.auth.device.api.Listener
import com.amazon.identity.auth.device.api.authorization.*
import com.amazon.identity.auth.device.api.workflow.RequestContext
import com.google.gson.Gson
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/**
 * LoginResponse
 *
 * @property eventName
 * @property user_id
 * @property email
 * @property name
 * @property user
 * @property accessToken
 */
class LoginResponse(
  private val eventName: String,
  private val user_id: String?,
  private val email: String?,
  private val name: String?,
  private val accessToken: String?,
  private val postalCode: String?
)

/** LwaPlugin */
class LwaPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel : MethodChannel
  private lateinit var eventChannel: EventChannel
  private var eventChannelHandler: EventChannelHandler? = null
  private val EVENT_CHANNEL = "lwa.authentication"
  private lateinit var activity: Activity
  private lateinit var scopes: List<String>

  private lateinit var requestContext: RequestContext

  @RequiresApi(Build.VERSION_CODES.O)
  @SuppressLint("PackageManagerGetSignatures")
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "lwa")
    channel.setMethodCallHandler(this)
    eventChannel = EventChannel(flutterPluginBinding.getBinaryMessenger(), EVENT_CHANNEL)
    eventChannelHandler = eventChannelHandler
      ?: EventChannelHandler()
    eventChannel.setStreamHandler(eventChannelHandler)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "signIn") {
      scopes = call.argument("scopes")!!
      return signIn(result)
    }
    if(call.method == "signOut") {
      return signOut(result)
    }
    else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  fun broadcastSuccess(result: String) {
    eventChannelHandler?.onSuccess(result.toString())
  }

  fun broadcastError(data: String) {
    eventChannelHandler?.onError(data.toString())
  }

  fun buildJson(response: LoginResponse): String {
    val gson = Gson()
    return gson.toJson(response)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    requestContext = RequestContext.create(activity.applicationContext)
    requestContext.registerListener(object : AuthorizeListener() {
      override fun onSuccess(result: AuthorizeResult) {
        activity.runOnUiThread {
          broadcastSuccess(buildJson(LoginResponse(
            "loginSuccess",
            result.user.userId,
            result.user.userEmail,
            result.user.userName,
            result.accessToken,
            result.user.userPostalCode
          )))
        }
      }

      override fun onError(ae: AuthError) {
        activity.runOnUiThread {
          broadcastError( buildJson(LoginResponse(
            "loginError",
            null,
            null,
            null,
            null,
            null
          )))
        }
      }

      override fun onCancel(cancellation: AuthCancellation) {
        activity.runOnUiThread {
          broadcastError(buildJson(
            LoginResponse(
              "loginCancelled",
              null,
              null,
              null,
              null,
              null
            )
          ))
        }
      }
    })
  }

  fun signIn(@NonNull result: Result) {
    val builder = AuthorizeRequest
            .Builder(requestContext)

    builder.addScope(ProfileScope.profile())
    if(scopes.contains("postal_code")) {
      builder.addScope(ProfileScope.postalCode())
    }

    val authorizeRequest: AuthorizeRequest = builder.build()

    AuthorizationManager
      .authorize(authorizeRequest)
    result.success("ok")
  }

  fun signOut(@NonNull result: Result) {
      AuthorizationManager.signOut(activity.applicationContext, object :
        Listener<Void?, AuthError?> {
        override fun onSuccess(response: Void?) {
          activity.runOnUiThread {
            broadcastSuccess(buildJson(LoginResponse(
              "logoutSuccess",
              null,
              null,
              null,
              null,
              null
            )))
          }
        }
        override fun onError(p0: AuthError?) {
          broadcastSuccess(buildJson(LoginResponse(
            "logoutError",
            null,
            null,
            null,
            null,
            null
          )))
        }
      })
      result.success("ok")
    }

  override fun onDetachedFromActivityForConfigChanges() {
   // TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
   // TODO("Not yet implemented")
  }

  override fun onDetachedFromActivity() {
   // TODO("Not yet implemented")
  }
}

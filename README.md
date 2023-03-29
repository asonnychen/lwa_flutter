# Login With Amazon

A Login With Amazon plugin for Flutter on iOS (Swift) and Android (Kotlin).  
Supports basic authentication with the Amazon web API.

Authors:  **Firedance Multimedia LLC**

License:  **MIT License**

## Getting Started
[The Official LWA Android Documentation](https://developer.amazon.com/docs/login-with-amazon/create-android-project.html#install-lwa-library)

[The Official LWA iOS Documentation](https://developer.amazon.com/docs/login-with-amazon/ios-docs.html)

## iOS Setup Instructions
- Visit [the Amazon Developer Console](https://developer.amazon.com/apps-and-games/login-with-amazon)
- Register your iOS app including the bundle ID for your application
- In your `Info.plist` set a key/value pair called apiKey (see example Info.plist)
- Enter the apiKey provided by the Amazon Developer Console
- Add your CFBundleURLTypes key to the iOS Properties file.  Include the bundle ID of your application, and update the URL Scheme to `amzn-your.bundle.id` (see example Info.plist)

## Android Setup Instructions
- Visit [the Amazon Developer Console](https://developer.amazon.com/apps-and-games/login-with-amazon)
- Register your Android bundle including your application identifier
- To retrieve your applications' md5 hash:
```
$ keytool -exportcert -alias your_alias -keystore /path/to/debug.keystore | \\
openssl dgst -md5 | \\
sed 's/[a-fA-F0-9][a-fA-F0-9]/&:/g; s/:$//'
```
- For the SHA256 fingerprint run:
```
$ keytool -v -list -keystore /path/to/debug.keystore
```
- In the `/andrid/app/src/main` directory, add an `assets` folder and paste the api key into a file
- Ensure the api key matches with no extra whitespace and name the file `api_key.txt` (see example android folder)
- Add the Login With Amazon workflow to your `AndroidManifest.xml` file

```
      <activity android:name="com.amazon.identity.auth.device.workflow.WorkflowActivity"
            android:theme="@android:style/Theme.NoDisplay"
            android:allowTaskReparenting="true"
            android:launchMode="singleTask"
            android:exported="true"
        >
            <intent-filter>
                <action android:name="android.intent.action.VIEW"/>
                <category android:name="android.intent.category.DEFAULT"/>
                <category android:name="android.intent.category.BROWSABLE"/>
                <!-- android:host must use the full package name found in Manifest General Attributes -->
                <data android:host="${applicationId}" android:scheme="amzn"/>
            </intent-filter>
        </activity>
```

## Documentation


### The LWA Plugin
Instantiate the LWA plugin inside of your application.

```
final _lwaPlugin = Lwa();
```

Start a stream to listen for LWA login and logout events.

```
 _lwaPlugin.getLWAAuthState().listen((event) {
    ...code
  });
```

### Methods

**signIn(scopes)**

```
await _lwaPlugin.signIn(scopes: ["profile"]);
```

Begins the authentication process with Login With Amazon.  Accepts an optional array of scopes.

**signOut()**

```
await _lwaPlugin.signOut();
```

Logs the user out of Amazon, expiring their access token.


### Events

The `signIn()` and `signOut()` methods will broadcast events on the LWAAuthState stream.  The event payloads are as follows:

**loginSuccess**

```
Map <response> - {
    eventName: loginSuccess,
    user_id: String containing the unique Amazon user ID,
    name: String containing the Amazon users name,
    email: String containing the Amazon users email,
    accessToken: String containing the authentication token for the user
}
```

Fires when a user successfully completes the authentication process.

**logoutSuccess**

```
Map <response> - {
    eventName: logoutSuccess
}
```

Fires when a user signs out from the Amazon service.

**loginCancelled**

```
Map <response> - {
    eventName: loginCancelled
}
```

Fires when a user cancels the authentication process.

**loginError**

```
Map <response> - {
    eventName: loginError
}
```

Fires when there is an error during the authentication process.  Check the debug output for details.

**logoutError**

```
Map <response> - {
    eventName: logoutError
}
```

Fires when there is an error during the authentication process.  Check the debug output for details.







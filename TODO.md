# TODO

## Implementing remember me

### Logic for main.dart

- The initial route will change depend on whether or not remember me = true
    - If false / invalid, initial route => /login
    - If true, initial route => /loginsuccessful

### Storing unique User Ids on device

- [ x ] Use the flutter_secure_storage package
    - Hash the username and use it as the userId for redis

        - example (rewrite the new value on login):
        
                import 'package:flutter_secure_storage/flutter_secure_storage.dart';

                // Create storage
                final storage = new FlutterSecureStorage();

                // Write value
                await storage.write(key: 'user_id', value: 'your_user_id');

                // Read value
                String? userId = await storage.read(key: 'user_id');
        
        - On each new login, rewrite the value for the user_id
        - Ex: If the user logins in w/ new username, override the user_id w/ the new hashed one
            - In this case using sha256 is more reasonable as this is supposed to be quick
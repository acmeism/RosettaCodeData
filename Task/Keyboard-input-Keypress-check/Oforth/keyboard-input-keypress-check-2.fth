System.Console receive ->key                 // Wait until a key is pressed ( = receiveTimeout(null) )
System.Console receiveChar ->aChar           // Wait until a character is pressed. All other keys are ignored
System.Console receiveTimeout(0) ->key       // Check if a key is pressed and return immediatly

import "./debug" for Debug

var x = 42
Debug.assert("x == 42", 4, x == 42) // fine
Debug.off
Debug.assert("x > 42", 6, x > 42)   // no error
Debug.on
Debug.assert("x > 42", 8, x > 42)   // error

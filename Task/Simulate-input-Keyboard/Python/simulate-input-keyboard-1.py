import autopy
autopy.key.type_string("Hello, world!") # Prints out "Hello, world!" as quickly as OS will allow.
autopy.key.type_string("Hello, world!", wpm=60) # Prints out "Hello, world!" at 60 WPM.
autopy.key.tap(autopy.key.Code.RETURN)
autopy.key.tap(autopy.key.Code.F1)
autopy.key.tap(autopy.key.Code.LEFT_ARROW)

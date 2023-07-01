alien = require("alien")
msgbox = alien.User32.MessageBoxA
msgbox:types({ ret='long', abi='stdcall', 'long', 'string', 'string', 'long' })
retval = msgbox(0, 'Please press Yes, No or Cancel', 'The Title', 3)
print(retval) --> 6, 7 or 2

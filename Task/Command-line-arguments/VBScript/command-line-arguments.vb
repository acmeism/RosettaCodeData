'Command line arguments can be accessed all together by

For Each arg In Wscript.Arguments
    Wscript.Echo "arg=", arg
Next

'You can access only the named arguments such as /arg:value

For Each arg In Wscript.Arguments.Named
    Wscript.Echo "name=", arg, "value=", Wscript.Arguments.Named(arg)
Next

'Or just the unnamed arguments

For Each arg In Wscript.Arguments.Unnamed
    Wscript.Echo "arg=", arg
Next

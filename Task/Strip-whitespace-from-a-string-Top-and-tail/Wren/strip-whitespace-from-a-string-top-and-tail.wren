var a = " \t\r\nString with leading whitespace removed"
var b = "String with trailing whitespace removed \t\r\n"
var c = " \t\r\nString with both leading and trailing whitespace removed \t\r\n"
var d = " \t\r\n\f\vString with leading whitespace, form feed and verical tab characters removed"
System.print("'%(a.trimStart())'")
System.print("'%(b.trimEnd())'")
System.print("'%(c.trim())'")
System.print("'%(d.trimStart(" \t\r\n\f\v"))'") // similar overloads of trimEnd and trim exist

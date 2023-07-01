import "/fmt" for Fmt

// simple string literal
System.print("Hello world!")

// string literal including an escape sequence
System.print("Hello tabbed\tworld!")

// interpolated string literal
var w = "world"
System.print("Hello interpolated %(w)!")

// 'printf' style
Fmt.print("Hello 'printf' style $s!", w)

// more complicated interpolated string literal
var h = "Hello"
System.print("%(Fmt.s(-8, h)) more complicated interpolated %(w.map { |c| "%(c + "\%")" }.join())!")

// more complicated 'printf' style
Fmt.print("$-8s more complicated 'printf' style $s\%!", h, w.join("\%"))

// raw string literal
var r = """
Hello, raw string literal which interpets a control code such as "\n" and an
interpolation such as %(h) as verbatim text.
Single (") or dual ("") double-quotes can be included without problem.
"""
System.print(r)

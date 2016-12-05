func func1(f: String->String) -> String { return f("a string") }
func func2(s: String) -> String { return "func2 called with " + s }
println(func1(func2)) // prints "func2 called with a string"

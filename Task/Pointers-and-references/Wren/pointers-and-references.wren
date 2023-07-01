// This function takes a string (behaves like a value type) and a list (reference type).
// The value and the reference are copied to their respective parameters.
var f = Fn.new { |s, l|
    if (s.type != String) Fiber.abort("First parameter must be a string.")
    if (l.type != List)   Fiber.abort("Second parameter must be a list.")
    // add the first argument to the list
    l.add(s) // the original 'l' will reflect this
    // mutate the first argument by reversing it
    s = s[-1..0] // the original 's' will not reflect this
}

var s = "wren"
var l = ["magpie", "finch"]
f.call(s, l)
System.print(l)
System.print(s)

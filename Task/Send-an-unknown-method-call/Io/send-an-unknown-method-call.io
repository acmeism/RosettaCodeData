Example := Object clone
Example foo := method(x, 42+x)

name := "foo"
Example clone perform(name,5) println  // prints "47"

class Foo {
    static init() { __count = 0 } // set object counter to zero

    construct new() {
        __count = __count + 1 // increment object counter
        _number = __count // allocates a unique number to each object created
    }

    number { _number }
}

Foo.init() // set object counter to zero
var n = 10 // say
// Create a List of 'n' distinct Foo objects
var foos = List.filled(n, null)
for (i in 0...foos.count) foos[i] = Foo.new()
// Show they're distinct by printing out their object numbers
foos.each { |f| System.write("%(f.number) ") }
System.print("\n")

// Now create a second List where each of the 'n' elements is the same Foo object
var foos2 = List.filled(n, Foo.new())
// Show they're the same by printing out their object numbers
foos2.each { |f| System.write("%(f.number) ") }
System.print()

class Bear {
    // Constructs a Bear instance passing it a name
    // which is stored in the field _name
    // automatically created by Wren.
    construct new(name) { _name = name }

    // Property to get the name
    name { _name }

    // Method to make a noise.
    makeNoise() { System.print("Growl!") }
}

// Create a new Bear instance and assign a reference to it
// to the variable b.
var b = Bear.new("Bruno")

// Print the bear's name.
System.print("The bear is called %(b.name).")
// Make a noise.
b.makeNoise()

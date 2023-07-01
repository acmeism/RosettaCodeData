class Animal {
    construct new(name, age) {
        _name = name
        _age = age
    }

    name { _name }
    age  { _age }

    copy() { Animal.new(name, age) }

    toString { "Name: %(_name), Age: %(_age)" }
}

class Dog is Animal {
    construct new(name, age, breed) {
        super(name, age) // call Animal's constructor
        _breed = breed
    }

    // name and age properties will be inherited from Animal
    breed { _breed }

    copy() { Dog.new(name, age, breed) } // overrides Animal's copy() method

    toString { super.toString + ", Breed: %(_breed)" } // overrides Animal's toString method
}

var a = Dog.new("Rover", 3, "Terrier") // a's type is Dog
var b = a.copy() // a's copy() method is called and so b's type is Dog
System.print("Dog 'a' -> %(a)") // implicitly calls a's toString method
System.print("Dog 'b' -> %(b)") // ditto
System.print("Dog 'a' is %((Object.same(a, b)) ? "" : "not") the same object as Dog 'b'")

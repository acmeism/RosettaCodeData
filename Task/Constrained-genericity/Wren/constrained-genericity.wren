// abstract class
class Eatable {
    eat() { /* override in child class */ }
}

class FoodBox {
    construct new(contents) {
        if (contents.any { |e| !(e is Eatable) }) {
            Fiber.abort("All FoodBox elements must be eatable.")
        }
        _contents = contents
    }

    contents { _contents }
}

// Inherits from Eatable and overrides eat() method.
class Pie is Eatable {
    construct new(filling) { _filling = filling }

    eat() { System.print("%(_filling) pie, yum!") }
}

// Not an Eatable.
class Bicycle {
    construct new() {}
}

var items = [Pie.new("Apple"),  Pie.new("Gooseberry")]
var fb = FoodBox.new(items)
fb.contents.each { |item| item.eat() }
System.print()
items.add(Bicycle.new())
fb = FoodBox.new(items) // throws an error because Bicycle not eatable

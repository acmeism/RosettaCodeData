import "./str" for Str

// abstract class
class CarElement {
    accept(visitor) {}
}

// abstract class
class CarElementVisitor {
    visit(obj) {}
}

class Wheel is CarElement {
    construct new(name) {
        _name = name
    }

    name { _name }

    accept(visitor) {
        visitor.visit(this)
    }
}

class Body is CarElement {
    construct new() {}

    accept(visitor) {
        visitor.visit(this)
    }
}

class Engine is CarElement {
    construct new() {}

    accept(visitor) {
        visitor.visit(this)
    }
}

class Car is CarElement {
    construct new() {
        _elements = [
            Wheel.new("front left"), Wheel.new("front right"),
            Wheel.new("back left"), Wheel.new("back right"),
            Body.new(), Engine.new()
        ]
    }

    accept(visitor) {
        for (element in _elements) element.accept(visitor)
        visitor.visit(this)
    }
}

class CarElementDoVisitor is CarElementVisitor {
    construct new() {}

    visit(obj) {
        if (obj is Body) {
            System.print("Moving my body")
        } else if (obj is Car) {
            System.print("Starting my car")
        } else if (obj is Wheel) {
            System.print("Kicking my %(obj.name) wheel")
        } else if (obj is Engine) {
            System.print("Starting my engine")
        }
    }
}

class CarElementPrintVisitor is CarElementVisitor {
    construct new() {}

    visit(obj) {
        if ((obj is Body) || (obj is Car) || (obj is Engine)) {
            System.print("Visiting %(Str.lower(obj.type))")
        } else if (obj is Wheel) {
            System.print("Visiting %(obj.name) wheel")
        }
    }
}

var car = Car.new()
car.accept(CarElementPrintVisitor.new())
car.accept(CarElementDoVisitor.new())

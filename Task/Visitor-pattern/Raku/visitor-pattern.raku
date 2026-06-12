role CarElementVisitor { ... }

class CarElement {
    method accept(CarElementVisitor $visitor) {
        $visitor.visit: self
    }
}

class Body is CarElement { }

class Engine is CarElement { }

class Wheel is CarElement {
    has Str $.name is required;
}

class Car is CarElement {
    has CarElement @.elements = (
        Wheel.new(name => "front left"),
        Wheel.new(name => "front right"),
        Wheel.new(name => "rear left"),
        Wheel.new(name => "rear right"),
        Body.new,
        Engine.new
    );

    method accept(CarElementVisitor $visitor) {
        for @.elements -> $element { $element.accept: $visitor };
        $visitor.visit: self;
    }
}

role CarElementVisitor {
    method visit(CarElement $e) { ... }
}

class CarElementDoVisitor does CarElementVisitor {
    multi method visit(Body $e) {
        say "Moving my body.";
    }
    multi method visit(Car $e) {
        say "Starting my car.";
    }
    multi method visit(Wheel $e) {
        say "Kicking my { $e.name } wheel.";
    }
    multi method visit(Engine $e) {
        say "Starting my engine.";
    }
}

class CarElementPrintVisitor does CarElementVisitor {
    multi method visit(Body $e) {
        say "Visiting body.";
    }
    multi method visit(Car $e) {
        say "Visiting car.";
    }
    multi method visit(Wheel $e) {
        say "Visiting { $e.name } wheel.";
    }
    multi method visit(Engine $e) {
        say "Visiting engine.";
    }
}

my Car $car = Car.new;

$car.accept: CarElementPrintVisitor.new;
$car.accept: CarElementDoVisitor.new;

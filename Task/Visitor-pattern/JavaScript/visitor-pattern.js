// Base classes (JavaScript doesn't have interfaces, so we use base classes)
class CarElement {
    accept(visitor) {
        throw new Error("accept method must be implemented");
    }
}

class CarElementVisitor {
    visit(carElement) {
        throw new Error("visit method must be implemented");
    }
}

// Concrete car element classes
class Body extends CarElement {
    accept(visitor) {
        visitor.visit(this);
    }
}

class Engine extends CarElement {
    accept(visitor) {
        visitor.visit(this);
    }
}

class Wheel extends CarElement {
    constructor(name) {
        super();
        this.name = name;
    }

    getName() {
        return this.name;
    }

    accept(visitor) {
        visitor.visit(this);
    }
}

class Car extends CarElement {
    constructor() {
        super();
        this.elements = [
            new Wheel("front left"),
            new Wheel("front right"),
            new Wheel("back left"),
            new Wheel("back right"),
            new Body(),
            new Engine()
        ];
    }

    accept(visitor) {
        for (const element of this.elements) {
            element.accept(visitor);
        }
        visitor.visit(this);
    }
}

// Concrete visitor implementations
class CarElementDoVisitor extends CarElementVisitor {
    visit(carElement) {
        if (carElement instanceof Body) {
            console.log("Moving my body.");
        } else if (carElement instanceof Car) {
            console.log("Starting my car.");
        } else if (carElement instanceof Wheel) {
            console.log(`Kicking my ${carElement.getName()} wheel.`);
        } else if (carElement instanceof Engine) {
            console.log("Starting my engine.");
        }
    }
}

class CarElementPrintVisitor extends CarElementVisitor {
    visit(carElement) {
        if (carElement instanceof Body) {
            console.log("Visiting body.");
        } else if (carElement instanceof Car) {
            console.log("Visiting car.");
        } else if (carElement instanceof Wheel) {
            console.log(`Visiting my ${carElement.getName()} wheel.`);
        } else if (carElement instanceof Engine) {
            console.log("Visiting my engine.");
        }
    }
}

// Demo function (equivalent to main method)
function carVisitorDemo() {
    const car = new Car();

    const printVisitor = new CarElementPrintVisitor();
    car.accept(printVisitor);

    console.log(""); // Empty line for separation

    const doVisitor = new CarElementDoVisitor();
    car.accept(doVisitor);
}

// Run the demo
carVisitorDemo();

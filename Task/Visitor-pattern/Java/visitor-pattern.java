import java.util.ArrayList;
import java.util.List;

// Interface for car elements
interface CarElement {
    void accept(CarElementVisitor visitor);
}

// Interface for visitor
interface CarElementVisitor {
    void visit(CarElement carElement);
}

// Concrete car element classes
class Body implements CarElement {
    @Override
    public void accept(CarElementVisitor visitor) {
        visitor.visit(this);
    }
}

class Engine implements CarElement {
    @Override
    public void accept(CarElementVisitor visitor) {
        visitor.visit(this);
    }
}

class Wheel implements CarElement {
    private String name;

    public Wheel(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    @Override
    public void accept(CarElementVisitor visitor) {
        visitor.visit(this);
    }
}

class Car implements CarElement {
    private List<CarElement> elements;

    public Car() {
        elements = new ArrayList<>();
        elements.add(new Wheel("front left"));
        elements.add(new Wheel("front right"));
        elements.add(new Wheel("back left"));
        elements.add(new Wheel("back right"));
        elements.add(new Body());
        elements.add(new Engine());
    }

    @Override
    public void accept(CarElementVisitor visitor) {
        for (CarElement element : elements) {
            element.accept(visitor);
        }
        visitor.visit(this);
    }
}

// Concrete visitor implementations
class CarElementDoVisitor implements CarElementVisitor {
    @Override
    public void visit(CarElement carElement) {
        if (carElement instanceof Body) {
            System.out.println("Moving my body.");
        } else if (carElement instanceof Car) {
            System.out.println("Starting my car.");
        } else if (carElement instanceof Wheel) {
            Wheel wheel = (Wheel) carElement;
            System.out.println("Kicking my " + wheel.getName() + " wheel.");
        } else if (carElement instanceof Engine) {
            System.out.println("Starting my engine.");
        }
    }
}

class CarElementPrintVisitor implements CarElementVisitor {
    @Override
    public void visit(CarElement carElement) {
        if (carElement instanceof Body) {
            System.out.println("Visiting body.");
        } else if (carElement instanceof Car) {
            System.out.println("Visiting car.");
        } else if (carElement instanceof Wheel) {
            Wheel wheel = (Wheel) carElement;
            System.out.println("Visiting my " + wheel.getName() + " wheel.");
        } else if (carElement instanceof Engine) {
            System.out.println("Visiting my engine.");
        }
    }
}

public class CarVisitorDemo {
    public static void main(String[] args) {
        Car car = new Car();

        CarElementPrintVisitor printVisitor = new CarElementPrintVisitor();
        car.accept(printVisitor);

        CarElementDoVisitor doVisitor = new CarElementDoVisitor();
        car.accept(doVisitor);
    }
}

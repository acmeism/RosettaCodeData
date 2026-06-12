#include <iostream>
#include <vector>
#include <memory>
#include <string>

// Forward declarations
class CarElementVisitor;

// Abstract base class for car elements
class CarElement {
public:
    virtual ~CarElement() = default;
    virtual void accept(CarElementVisitor* visitor) = 0;
};

// Abstract visitor class
class CarElementVisitor {
public:
    virtual ~CarElementVisitor() = default;
    virtual void visit(CarElement* car_element) = 0;
};

// Concrete car element classes
class Body : public CarElement {
public:
    void accept(CarElementVisitor* visitor) override {
        visitor->visit(this);
    }
};

class Engine : public CarElement {
public:
    void accept(CarElementVisitor* visitor) override {
        visitor->visit(this);
    }
};

class Wheel : public CarElement {
private:
    std::string name;

public:
    explicit Wheel(const std::string& name) : name(name) {}

    const std::string& getName() const {
        return name;
    }

    void accept(CarElementVisitor* visitor) override {
        visitor->visit(this);
    }
};

class Car : public CarElement {
private:
    std::vector<std::unique_ptr<CarElement>> elements;

public:
    Car() {
        elements.push_back(std::make_unique<Wheel>("front left"));
        elements.push_back(std::make_unique<Wheel>("front right"));
        elements.push_back(std::make_unique<Wheel>("back left"));
        elements.push_back(std::make_unique<Wheel>("back right"));
        elements.push_back(std::make_unique<Body>());
        elements.push_back(std::make_unique<Engine>());
    }

    void accept(CarElementVisitor* visitor) override {
        for (auto& element : elements) {
            element->accept(visitor);
        }
        visitor->visit(this);
    }
};

// Concrete visitor implementations
class CarElementDoVisitor : public CarElementVisitor {
public:
    void visit(CarElement* car_element) override {
        // Use dynamic_cast to determine the actual type
        if (auto* body = dynamic_cast<Body*>(car_element)) {
            std::cout << "Moving my body." << std::endl;
        }
        else if (auto* car = dynamic_cast<Car*>(car_element)) {
            std::cout << "Starting my car." << std::endl;
        }
        else if (auto* wheel = dynamic_cast<Wheel*>(car_element)) {
            std::cout << "Kicking my " << wheel->getName() << " wheel." << std::endl;
        }
        else if (auto* engine = dynamic_cast<Engine*>(car_element)) {
            std::cout << "Starting my engine." << std::endl;
        }
    }
};

class CarElementPrintVisitor : public CarElementVisitor {
public:
    void visit(CarElement* car_element) override {
        // Use dynamic_cast to determine the actual type
        if (auto* body = dynamic_cast<Body*>(car_element)) {
            std::cout << "Visiting body." << std::endl;
        }
        else if (auto* car = dynamic_cast<Car*>(car_element)) {
            std::cout << "Visiting car." << std::endl;
        }
        else if (auto* wheel = dynamic_cast<Wheel*>(car_element)) {
            std::cout << "Visiting my " << wheel->getName() << " wheel." << std::endl;
        }
        else if (auto* engine = dynamic_cast<Engine*>(car_element)) {
            std::cout << "Visiting my engine." << std::endl;
        }
    }
};

int main() {
    Car car;

    CarElementPrintVisitor print_visitor;
    car.accept(&print_visitor);

    CarElementDoVisitor do_visitor;
    car.accept(&do_visitor);

    return 0;
}

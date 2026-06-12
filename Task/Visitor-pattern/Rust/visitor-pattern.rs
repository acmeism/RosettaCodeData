// Trait for car elements that can accept visitors
trait CarElement {
    fn accept(&self, visitor: &mut dyn CarElementVisitor);
}

// Trait for visitors
trait CarElementVisitor {
    fn visit_body(&mut self, body: &Body);
    fn visit_engine(&mut self, engine: &Engine);
    fn visit_wheel(&mut self, wheel: &Wheel);
    fn visit_car(&mut self, car: &Car);
}

// Concrete car element structs
struct Body;

impl CarElement for Body {
    fn accept(&self, visitor: &mut dyn CarElementVisitor) {
        visitor.visit_body(self);
    }
}

struct Engine;

impl CarElement for Engine {
    fn accept(&self, visitor: &mut dyn CarElementVisitor) {
        visitor.visit_engine(self);
    }
}

struct Wheel {
    name: String,
}

impl Wheel {
    fn new(name: &str) -> Self {
        Self {
            name: name.to_string(),
        }
    }

    fn get_name(&self) -> &str {
        &self.name
    }
}

impl CarElement for Wheel {
    fn accept(&self, visitor: &mut dyn CarElementVisitor) {
        visitor.visit_wheel(self);
    }
}

struct Car {
    elements: Vec<Box<dyn CarElement>>,
}

impl Car {
    fn new() -> Self {
        let mut elements: Vec<Box<dyn CarElement>> = Vec::new();
        elements.push(Box::new(Wheel::new("front left")));
        elements.push(Box::new(Wheel::new("front right")));
        elements.push(Box::new(Wheel::new("back left")));
        elements.push(Box::new(Wheel::new("back right")));
        elements.push(Box::new(Body));
        elements.push(Box::new(Engine));

        Self { elements }
    }
}

impl CarElement for Car {
    fn accept(&self, visitor: &mut dyn CarElementVisitor) {
        for element in &self.elements {
            element.accept(visitor);
        }
        visitor.visit_car(self);
    }
}

// Concrete visitor implementations
struct CarElementDoVisitor;

impl CarElementVisitor for CarElementDoVisitor {
    fn visit_body(&mut self, _body: &Body) {
        println!("Moving my body.");
    }

    fn visit_engine(&mut self, _engine: &Engine) {
        println!("Starting my engine.");
    }

    fn visit_wheel(&mut self, wheel: &Wheel) {
        println!("Kicking my {} wheel.", wheel.get_name());
    }

    fn visit_car(&mut self, _car: &Car) {
        println!("Starting my car.");
    }
}

struct CarElementPrintVisitor;

impl CarElementVisitor for CarElementPrintVisitor {
    fn visit_body(&mut self, _body: &Body) {
        println!("Visiting body.");
    }

    fn visit_engine(&mut self, _engine: &Engine) {
        println!("Visiting my engine.");
    }

    fn visit_wheel(&mut self, wheel: &Wheel) {
        println!("Visiting my {} wheel.", wheel.get_name());
    }

    fn visit_car(&mut self, _car: &Car) {
        println!("Visiting car.");
    }
}

fn main() {
    let car = Car::new();

    let mut print_visitor = CarElementPrintVisitor;
    car.accept(&mut print_visitor);

    let mut do_visitor = CarElementDoVisitor;
    car.accept(&mut do_visitor);
}

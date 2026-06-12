#[derive(Debug)]
struct Cuboid {
    length: f64,
    breadth: f64,
    height: f64,
}

impl Cuboid {
    fn new() -> Self {
        Cuboid {
            length: 0.0,
            breadth: 0.0,
            height: 0.0,
        }
    }

    fn get_volume(&self) -> f64 {
        self.length * self.breadth * self.height
    }

    fn set_length(&mut self, val: f64) {
        self.length = val;
    }

    fn set_breadth(&mut self, val: f64) {
        self.breadth = val;
    }

    fn set_height(&mut self, val: f64) {
        self.height = val;
    }

    fn add(&self, other: &Cuboid) -> Cuboid {
        Cuboid {
            length: self.length + other.length,
            breadth: self.breadth + other.breadth,
            height: self.height + other.height,
        }
    }

    fn subtract(&self, other: &Cuboid) -> Cuboid {
        Cuboid {
            length: self.length - other.length,
            breadth: self.breadth - other.breadth,
            height: self.height - other.height,
        }
    }
}

fn main() {
    let mut c1 = Cuboid::new();
    let mut c2 = Cuboid::new();
    let c3: Cuboid;

    c1.set_length(6.0);
    c1.set_breadth(7.0);
    c1.set_height(5.0);

    c2.set_length(12.0);
    c2.set_breadth(13.0);
    c2.set_height(10.0);

    let volume = c1.get_volume();
    println!("Volume of 1st cuboid: {}", volume);

    let volume = c2.get_volume();
    println!("Volume of 2nd cuboid: {}", volume);

    c3 = c1.add(&c2);
    let volume = c3.get_volume();
    println!("Volume of 3rd cuboid after adding: {}", volume);

    let c3 = c1.subtract(&c2);
    let volume = c3.get_volume();
    println!("Volume of 3rd cuboid after subtracting: {}", volume);
}


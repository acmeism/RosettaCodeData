#[derive(Debug)]
struct Vector {
    x: f64,
    y: f64,
    z: f64,
}

impl Vector {
    fn new(x: f64, y: f64, z: f64) -> Self {
        Vector {
            x: x,
            y: y,
            z: z,
        }
    }

    fn dot_product(&self, other: &Vector) -> f64 {
        (self.x * other.x) + (self.y * other.y) + (self.z * other.z)
    }

    fn cross_product(&self, other: &Vector) -> Vector {
        Vector::new(self.y * other.z - self.z * other.y,
                    self.z * other.x - self.x * other.z,
                    self.x * other.y - self.y * other.x)
    }

    fn scalar_triple_product(&self, b: &Vector, c: &Vector) -> f64 {
        self.dot_product(&b.cross_product(&c))
    }

    fn vector_triple_product(&self, b: &Vector, c: &Vector) -> Vector {
        self.cross_product(&b.cross_product(&c))
    }
}

fn main(){
    let a = Vector::new(3.0, 4.0, 5.0);
    let b = Vector::new(4.0, 3.0, 5.0);
    let c = Vector::new(-5.0, -12.0, -13.0);

    println!("a . b = {}", a.dot_product(&b));
    println!("a x b = {:?}", a.cross_product(&b));
    println!("a . (b x c) = {}", a.scalar_triple_product(&b, &c));
    println!("a x (b x c) = {:?}", a.vector_triple_product(&b, &c));
}

use std::f64::consts::PI;

#[derive(Debug, Clone, Copy)]
struct Vector {
    x: f64,
    y: f64,
    z: f64,
}

impl Vector {
    fn new(x: f64, y: f64, z: f64) -> Self {
        Vector { x, y, z }
    }

    fn unit_vector(&self) -> Self {
        self.scalar_multiply(1.0 / self.dot_product(*self).sqrt())
    }

    fn add(&self, other: &Vector) -> Self {
        Vector::new(self.x + other.x, self.y + other.y, self.z + other.z)
    }

    fn scalar_multiply(&self, value: f64) -> Self {
        Vector::new(self.x * value, self.y * value, self.z * value)
    }

    fn dot_product(&self, other: Vector) -> f64 {
        self.x * other.x + self.y * other.y + self.z * other.z
    }

    fn cross_product(&self, other: &Vector) -> Self {
        Vector::new(
            self.y * other.z - self.z * other.y,
            self.z * other.x - self.x * other.z,
            self.x * other.y - self.y * other.x,
        )
    }

    fn rodrigues_rotation(&self, vector: &Vector, angle: f64) -> Self {
        let axis = self.unit_vector();
        vector.scalar_multiply(angle.cos())
            .add(&axis.cross_product(vector).scalar_multiply(angle.sin()))
            .add(&axis.scalar_multiply(axis.dot_product(*vector) * (1.0 - angle.cos())))
    }

    fn display(&self) {
        print!("({:.4}, {:.4}, {:.4})", self.x, self.y, self.z);
    }
}

fn main() {
    let axis = Vector::new(-1.0, 2.0, 1.0);
    let vector = Vector::new(2.5, -1.5, 3.0);

    println!(" Angle         Rotated vector");
    println!("-----------------------------------");
    let mut theta = 0.0;
    while theta <= 2.0 * PI {
        let result = axis.rodrigues_rotation(&vector, theta);
        print!("{:.4}    ", theta);
        result.display();
        println!();
        theta += PI / 5.0;
    }
}

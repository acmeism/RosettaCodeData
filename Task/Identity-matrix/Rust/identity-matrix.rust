extern crate num;
struct Matrix<T> {
    data: Vec<T>,
    size: usize,
}

impl<T> Matrix<T>
where
    T: num::Num + Clone + Copy,
{
    fn new(size: usize) -> Self {
        Self {
            data: vec![T::zero(); size * size],
            size: size,
        }
    }
    fn get(&mut self, x: usize, y: usize) -> T {
        self.data[x + self.size * y]
    }
    fn identity(&mut self) {
        for (i, item) in self.data.iter_mut().enumerate() {
            *item = if i % (self.size + 1) == 0 {
                T::one()
            } else {
                T::zero()
            }
        }
    }
}

fn main() {
    let size = std::env::args().nth(1).unwrap().parse().unwrap();
    let mut matrix = Matrix::<i32>::new(size);
    matrix.identity();
    for y in 0..size {
        for x in 0..size {
            print!("{} ", matrix.get(x, y));
        }
        println!();
    }
}

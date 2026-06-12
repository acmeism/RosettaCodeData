use rand::{rng, Rng};
use std::fmt;
use std::ops::{Add, Index, IndexMut, Mul, Neg};

fn uniform01() -> f64 {
    let mut rng = rng();
    rng.r#gen::<f64>()
}

fn bit_count(mut i: i32) -> i32 {
    i -= (i >> 1) & 0x55555555;
    i = (i & 0x33333333) + ((i >> 2) & 0x33333333);
    i = (i + (i >> 4)) & 0x0F0F0F0F;
    i += i >> 8;
    i += i >> 16;
    i & 0x0000003F
}

fn reordering_sign(i: usize, j: usize) -> f64 {
    let mut k = i >> 1;
    let mut sum = 0;
    while k != 0 {
        sum += bit_count((k & j) as i32);
        k >>= 1;
    }
    if (sum & 1) == 0 { 1.0 } else { -1.0 }
}

#[derive(Clone, Debug)]
struct MyVector {
    dims: Vec<f64>,
}

impl MyVector {
    fn new(dims: Vec<f64>) -> Self {
        Self { dims }
    }

    fn dot(&self, rhs: &MyVector) -> MyVector {
        (self * rhs + rhs * self) * 0.5
    }
}

impl Index<usize> for MyVector {
    type Output = f64;

    fn index(&self, index: usize) -> &Self::Output {
        &self.dims[index]
    }
}

impl IndexMut<usize> for MyVector {
    fn index_mut(&mut self, index: usize) -> &mut Self::Output {
        &mut self.dims[index]
    }
}

impl Add<&MyVector> for &MyVector {
    type Output = MyVector;

    fn add(self, rhs: &MyVector) -> Self::Output {
        let mut temp = self.dims.clone();
        for i in 0..rhs.dims.len() {
            temp[i] += rhs[i];
        }
        MyVector::new(temp)
    }
}

impl Add<MyVector> for &MyVector {
    type Output = MyVector;

    fn add(self, rhs: MyVector) -> Self::Output {
        self + &rhs
    }
}

impl Add<&MyVector> for MyVector {
    type Output = MyVector;

    fn add(self, rhs: &MyVector) -> Self::Output {
        &self + rhs
    }
}

impl Add<MyVector> for MyVector {
    type Output = MyVector;

    fn add(self, rhs: MyVector) -> Self::Output {
        &self + &rhs
    }
}

impl Mul<&MyVector> for &MyVector {
    type Output = MyVector;

    fn mul(self, rhs: &MyVector) -> Self::Output {
        let mut temp = vec![0.0; self.dims.len()];
        for i in 0..self.dims.len() {
            if self.dims[i] != 0.0 {
                for j in 0..self.dims.len() {
                    if rhs[j] != 0.0 {
                        let s = reordering_sign(i, j) * self.dims[i] * rhs[j];
                        let k = i ^ j;
                        temp[k] += s;
                    }
                }
            }
        }
        MyVector::new(temp)
    }
}

impl Mul<MyVector> for &MyVector {
    type Output = MyVector;

    fn mul(self, rhs: MyVector) -> Self::Output {
        self * &rhs
    }
}

impl Mul<&MyVector> for MyVector {
    type Output = MyVector;

    fn mul(self, rhs: &MyVector) -> Self::Output {
        &self * rhs
    }
}

impl Mul<MyVector> for MyVector {
    type Output = MyVector;

    fn mul(self, rhs: MyVector) -> Self::Output {
        &self * &rhs
    }
}

impl Mul<f64> for &MyVector {
    type Output = MyVector;

    fn mul(self, scale: f64) -> Self::Output {
        let temp: Vec<f64> = self.dims.iter().map(|&a| a * scale).collect();
        MyVector::new(temp)
    }
}

impl Mul<f64> for MyVector {
    type Output = MyVector;

    fn mul(self, scale: f64) -> Self::Output {
        &self * scale
    }
}

impl Neg for MyVector {
    type Output = MyVector;

    fn neg(self) -> Self::Output {
        self * -1.0
    }
}

impl Neg for &MyVector {
    type Output = MyVector;

    fn neg(self) -> Self::Output {
        self * -1.0
    }
}

impl fmt::Display for MyVector {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "[")?;
        for (i, &val) in self.dims.iter().enumerate() {
            if i > 0 {
                write!(f, ", ")?;
            }
            write!(f, "{}", val)?;
        }
        write!(f, "]")
    }
}

fn e(n: usize) -> Result<MyVector, String> {
    if n > 4 {
        return Err("n must be less than 5".to_string());
    }

    let mut result = MyVector::new(vec![0.0; 32]);
    result[1 << n] = 1.0;
    Ok(result)
}

fn random_vector() -> MyVector {
    let mut result = MyVector::new(vec![0.0; 32]);
    for i in 0..5 {
        let basis = e(i).unwrap();
        let scalar_vec = MyVector::new(vec![uniform01()]);
        result = result + scalar_vec * basis;
    }
    result
}

fn random_multi_vector() -> MyVector {
    let mut result = MyVector::new(vec![0.0; 32]);
    for i in 0..32 {
        result[i] = uniform01();
    }
    result
}

fn main() -> Result<(), String> {
    // Test orthogonality of basis vectors
    for i in 0..5 {
        for j in 0..5 {
            if i < j {
                let ei = e(i)?;
                let ej = e(j)?;
                if ei.dot(&ej)[0] != 0.0 {
                    println!("Unexpected non-null scalar product.");
                    return Err("Test failed".to_string());
                }
            } else if i == j {
                let ei = e(i)?;
                if ei.dot(&ei)[0] == 0.0 {
                    println!("Unexpected null scalar product.");
                }
            }
        }
    }

    let a = random_multi_vector();
    let b = random_multi_vector();
    let c = random_multi_vector();
    let x = random_vector();

    // (ab)c == a(bc) - Associativity test
    println!("{}", (&a * &b) * &c);
    println!("{}\n", &a * (&b * &c));

    // a(b+c) == ab + ac - Left distributivity test
    println!("{}", &a * (&b + &c));
    println!("{}\n", &a * &b + &a * &c);

    // (a+b)c == ac + bc - Right distributivity test
    println!("{}", (&a + &b) * &c);
    println!("{}\n", &a * &c + &b * &c);

    // x^2 is real (should have only scalar component)
    println!("{}", &x * &x);

    Ok(())
}

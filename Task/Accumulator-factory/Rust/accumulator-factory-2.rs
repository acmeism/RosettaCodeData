// Accumulator
#![feature(unboxed_closures, fn_traits)]

pub struct Accumulator<T> {
    value: T,
}

impl<T> Accumulator<T> {
    pub fn new(value: T) -> Self {
        Self { value }
    }
}

impl<T, N> FnOnce<(N,)> for Accumulator<T>
where
    T: std::ops::AddAssign<N> + Clone,
{
    type Output = T;
    extern "rust-call" fn call_once(mut self, (n,): (N,)) -> T {
        self.value += n;
        self.value
    }
}

impl<T, N> FnMut<(N,)> for Accumulator<T>
where
    T: std::ops::AddAssign<N> + Clone,
{
    extern "rust-call" fn call_mut(&mut self, (n,): (N,)) -> T {
        self.value += n;
        self.value.clone()
    }
}

// Number
#[derive(Copy, Clone, Debug)]
pub enum Number {
    Int(i64),
    Float(f64),
}

impl From<i64> for Number {
    fn from(int: i64) -> Number {
        Number::Int(int)
    }
}

impl From<f64> for Number {
    fn from(float: f64) -> Number {
        Number::Float(float)
    }
}

impl std::ops::AddAssign<i64> for Number {
    fn add_assign(&mut self, n: i64) {
        match self {
            Number::Int(s) => *s += n,
            Number::Float(s) => *s += n as f64,
        }
    }
}

impl std::ops::AddAssign<f64> for Number {
    fn add_assign(&mut self, n: f64) {
        *self = match *self {
            Number::Int(s) => Number::Float(s as f64 + n),
            Number::Float(s) => Number::Float(s + n),
        }
    }
}

impl std::fmt::Display for Number {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Number::Int(x) => write!(f, "{}", x),
            Number::Float(x) => write!(f, "{}", x),
        }
    }
}

// Demonstration
fn foo(n: impl Into<Number>) -> Accumulator<Number> {
    Accumulator::new(n.into())
}

fn main() {
    let mut x = foo(1);
    x(5);
    foo(3);
    println!("{}", x(2.3));

    let mut s = Accumulator::new(String::from("rosetta"));
    s(" ");
    println!("{}", s("code"));
}

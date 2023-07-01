use std::rc::Rc;
use std::ops::{Add, Mul};

#[derive(Clone)]
struct Church<'a, T: 'a> {
    runner: Rc<dyn Fn(Rc<dyn Fn(T) -> T + 'a>) -> Rc<dyn Fn(T) -> T + 'a> + 'a>,
}

impl<'a, T> Church<'a, T> {
    fn zero() -> Self {
        Church {
            runner: Rc::new(|_f| {
                Rc::new(|x| x)
            })
        }
    }

    fn succ(self) -> Self {
        Church {
            runner: Rc::new(move |f| {
                let g = self.runner.clone();
                Rc::new(move |x| f(g(f.clone())(x)))
            })
        }
    }

    fn run(&self, f: impl Fn(T) -> T + 'a) -> Rc<dyn Fn(T) -> T + 'a> {
        (self.runner)(Rc::new(f))
    }

    fn exp(self, rhs: Church<'a, Rc<dyn Fn(T) -> T + 'a>>) -> Self
    {
        Church {
            runner: (rhs.runner)(self.runner)
        }
    }
}

impl<'a, T> Add for Church<'a, T> {
    type Output = Church<'a, T>;

    fn add(self, rhs: Church<'a, T>) -> Church<T> {
        Church {
            runner: Rc::new(move |f| {
                let self_runner = self.runner.clone();
                let rhs_runner = rhs.runner.clone();
                Rc::new(move |x| (self_runner)(f.clone())((rhs_runner)(f.clone())(x)))
            })
        }
    }
}

impl<'a, T> Mul for Church<'a, T> {
    type Output = Church<'a, T>;

    fn mul(self, rhs: Church<'a, T>) -> Church<T> {
        Church {
            runner: Rc::new(move |f| {
                (self.runner)((rhs.runner)(f))
            })
        }
    }
}

impl<'a, T> From<i32> for Church<'a, T> {
    fn from(n: i32) -> Church<'a, T> {
        let mut ret = Church::zero();
        for _ in 0..n {
            ret = ret.succ();
        }
        ret
    }
}

impl<'a> From<&Church<'a, i32>> for i32  {
    fn from(c: &Church<'a, i32>) -> i32 {
        c.run(|x| x + 1)(0)
    }
}

fn three<'a, T>() -> Church<'a, T> {
    Church::zero().succ().succ().succ()
}

fn four<'a, T>() -> Church<'a, T> {
    Church::zero().succ().succ().succ().succ()
}

fn main() {
    println!("three =\t{}", i32::from(&three()));
    println!("four =\t{}", i32::from(&four()));

    println!("three + four =\t{}", i32::from(&(three() + four())));
    println!("three * four =\t{}", i32::from(&(three() * four())));

    println!("three ^ four =\t{}", i32::from(&(three().exp(four()))));
    println!("four ^ three =\t{}", i32::from(&(four().exp(three()))));
}

use std::{
    marker::PhantomData,
    f64::consts::PI,
};

pub trait AngleUnit: Copy {
    const TURN: f64;
    const NAME: &'static str;
}

macro_rules! unit {
    ($name:ident, $value:expr, $string:expr) => (
        #[derive(Debug, Copy, Clone)]
        struct $name;
        impl AngleUnit for $name {
            const TURN: f64 = $value;
            const NAME: &'static str = $string;
        }
    );
}

unit!(Degrees,  360.0,      "Degrees");
unit!(Radians,  PI * 2.0,   "Radians");
unit!(Gradians, 400.0,      "Gradians");
unit!(Mils,     6400.0,     "Mils");

#[derive(Copy, Clone, PartialEq, PartialOrd)]
struct Angle<T: AngleUnit>(f64, PhantomData<T>);

impl<T: AngleUnit> Angle<T> {
    pub fn new(val: f64) -> Self {
        Self(val, PhantomData)
    }

    pub fn normalize(self) -> Self {
        Self(self.0 % T::TURN, PhantomData)
    }

    pub fn val(self) -> f64 {
        self.0
    }

    pub fn convert<U: AngleUnit>(self) -> Angle<U> {
        Angle::new(self.0 * U::TURN / T::TURN)
    }

    pub fn name(self) -> &'static str {
        T::NAME
    }
}

fn print_angles<T: AngleUnit>() {
    let angles = [-2.0, -1.0, 0.0, 1.0, 2.0, 6.2831853, 16.0, 57.2957795, 359.0, 399.0, 6399.0, 1000000.0];
    println!("{:<12} {:<12} {:<12} {:<12} {:<12} {:<12}", "Angle", "Unit", "Degrees", "Gradians", "Mils", "Radians");

    for &angle in &angles {
        let deg = Angle::<T>::new(angle).normalize();
        println!("{:<12} {:<12} {:<12.4} {:<12.4} {:<12.4} {:<12.4}",
                 angle,
                 deg.name(),
                 deg.convert::<Degrees>().val(),
                 deg.convert::<Gradians>().val(),
                 deg.convert::<Mils>().val(),
                 deg.convert::<Radians>().val(),
        );
    }

    println!();
}

fn main() {
    print_angles::<Degrees>();
    print_angles::<Gradians>();
    print_angles::<Mils>();
    print_angles::<Radians>();
}

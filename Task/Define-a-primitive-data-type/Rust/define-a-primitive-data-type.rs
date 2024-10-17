use std::convert::TryFrom;

mod test_mod {
    use std::convert::TryFrom;
    use std::fmt;

    // Because the `i8` is not `pub` this cannot be directly constructed
    // by code outside this module
    #[derive(Copy, Clone, Debug)]
    pub struct TwoDigit(i8);

    impl TryFrom<i8> for TwoDigit {
        type Error = &'static str;

        fn try_from(value: i8) -> Result<Self, Self::Error> {
            if value < -99 || value > 99 {
                Err("Number cannot fit into two decimal digits")
            } else {
                Ok(TwoDigit(value))
            }
        }
    }

    impl Into<i8> for TwoDigit {
        fn into(self) -> i8 { self.0 }
    }

    // This powers `println!`'s `{}` token.
    impl fmt::Display for TwoDigit {
        fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
            write!(f, "{}", self.0)
        }
    }
}

pub fn main() {
    let foo = test_mod::TwoDigit::try_from(50).unwrap();
    let bar: i8 = foo.into();
    println!("{} == {}", foo, bar);
}

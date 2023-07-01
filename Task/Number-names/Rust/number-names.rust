use std::io::{self, Write, stdout};

const SMALL: &[&str] = &[
    "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
    "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen",
    "nineteen",
];

const TENS: &[&str] = &[
    "PANIC", "PANIC", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety",
];

const MAGNITUDE: &[&str] = &[
    "PANIC", "thousand", "million", "billion", "trillion", "quadrillion", "quintillion",
];

fn wordify<W: Write>(w: &mut W, mut number: i64) -> Result<(), io::Error> {
    if number == 0 {
        return write!(w, "zero");
    }
    if number < 0 {
        write!(w, "negative ")?;
        number = -number;
    }
    while number != 0 {
        if number < 20 {
            write!(w, "{}", SMALL[number as usize])?;
            break;
        } else if number < 100 {
            write!(w, "{}", TENS[number as usize / 10])?;
            number %= 10;
            if number != 0 {
                write!(w, "-")?;
            }
        } else if number < 1_000 {
            write!(w, "{} hundred", SMALL[number as usize / 100])?;
            number %= 100;
            if number != 0 {
                write!(w, " and ")?;
            }
        } else {
            let mut top = number;
            let mut magnitude = 0i64;
            let mut magnitude_pow = 1i64;
            while top >= 1_000 {
                top /= 1_000;
                magnitude += 1;
                magnitude_pow *= 1_000;
            }
            wordify(w, top)?;
            number %= magnitude_pow;
            if number == 0 {
                write!(w, " {}", MAGNITUDE[magnitude as usize])?;
            } else if number > 100 {
                write!(w, " {}, ", MAGNITUDE[magnitude as usize])?;
            } else {
                write!(w, " {} and ", MAGNITUDE[magnitude as usize])?;
            }
        }
    }
    Ok(())
}

fn main() {
    let stdout = stdout();
    let mut stdout = stdout.lock();
    for &n in &[12, 1048576, 9_000_000_000_000_000_000, -2, 0, 5_000_000_000_000_000_001, -555_555_555_555] {
        wordify(&mut stdout, n).unwrap();
        write!(&mut stdout, "\n").unwrap();
    }
}

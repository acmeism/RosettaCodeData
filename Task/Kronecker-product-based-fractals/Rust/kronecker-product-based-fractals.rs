use std::{
    fmt::{Debug, Display, Write},
    ops::Mul,
};

// Rust has (almost) no built-in support for multi-dimensional arrays or so.
// Let's make a basic one ourselves for our use cases.

#[derive(Clone, Debug)]
pub struct Mat<T> {
    col_count: usize,
    row_count: usize,
    items: Vec<T>,
}

impl<T> Mat<T> {
    pub fn from_vec(items: Vec<T>, col_count: usize, row_count: usize) -> Self {
        assert_eq!(items.len(), col_count * row_count, "mismatching dimensions");

        Self {
            col_count,
            row_count,
            items,
        }
    }

    pub fn row_count(&self) -> usize {
        self.row_count
    }

    pub fn col_count(&self) -> usize {
        self.col_count
    }

    pub fn iter(&self) -> impl Iterator<Item = &T> {
        self.items.iter()
    }

    pub fn row_iter(&self, row: usize) -> impl Iterator<Item = &T> {
        assert!(row < self.row_count, "index out of bounds");
        let start = row * self.col_count;
        self.items[start..start + self.col_count].iter()
    }

    pub fn col_iter(&self, col: usize) -> impl Iterator<Item = &T> {
        assert!(col < self.col_count, "index out of bounds");
        self.items.iter().skip(col).step_by(self.col_count)
    }
}

impl<T: Display> Display for Mat<T> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        // Compute the width of the widest item first
        let mut len = 0usize;
        let mut buf = String::new();
        for item in (0..self.row_count).flat_map(|row| self.row_iter(row)) {
            buf.clear();
            write!(buf, "{}", item)?;
            len = std::cmp::max(len, buf.chars().count());
        }

        // Then render the matrix with proper padding

        len += 1; // To separate cells
        let width = len * self.col_count + 1;
        writeln!(f, "┌{:width$}┐", "", width = width)?;

        for row in (0..self.row_count).map(|row| self.row_iter(row)) {
            write!(f, "│")?;

            for item in row {
                write!(f, "{:>width$}", item, width = len)?;
            }

            writeln!(f, " │")?;
        }

        write!(f, "└{:width$}┘", "", width = width)
    }
}

// Rust standard libraries have no graphics support. If we want to render
// an image, we can write, e.g., a PPM file.

impl<T> Mat<T> {
    pub fn write_ppm(
        &self,
        f: &mut dyn std::io::Write,
        rgb: impl Fn(&T) -> (u8, u8, u8),
    ) -> std::io::Result<()> {
        let bytes = self
            .iter()
            .map(rgb)
            .flat_map(|(r, g, b)| {
                use std::iter::once;
                once(r).chain(once(g)).chain(once(b))
            })
            .collect::<Vec<u8>>();

        write!(f, "P6\n{} {}\n255\n", self.col_count, self.row_count)?;
        f.write_all(&bytes)
    }
}

mod kronecker {

    use super::Mat;
    use std::ops::Mul;

    // Look ma, no numbers! We can combine anything with Mul (see later)

    pub fn product<T, U>(a: &Mat<T>, b: &Mat<U>) -> Mat<<T as Mul<U>>::Output>
    where
        T: Clone + Mul<U>,
        U: Clone,
    {
        let row_count = a.row_count() * b.row_count();
        let col_count = a.col_count() * b.col_count();
        let mut items = Vec::with_capacity(row_count * col_count);

        for i in 0..a.row_count() {
            for k in 0..b.row_count() {
                for a_x in a.row_iter(i) {
                    for b_x in b.row_iter(k) {
                        items.push(a_x.clone() * b_x.clone());
                    }
                }
            }
        }

        Mat::from_vec(items, col_count, row_count)
    }

    pub fn power<T>(m: &Mat<T>, n: u32) -> Mat<T>
    where
        T: Clone + Mul<T, Output = T>,
    {
        match n {
            0 => m.clone(),
            _ => (1..n).fold(product(&m, &m), |result, _| product(&result, &m)),
        }
    }
}

// Here we make a char-like type with Mul implementation.
// We can do fancy things with that later.

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct Char(char);

impl Char {
    fn space() -> Self {
        Char(' ')
    }

    fn is_space(&self) -> bool {
        self.0 == ' '
    }
}

impl Display for Char {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        Display::fmt(&self.0, f)
    }
}

impl Mul for Char {
    type Output = Self;

    #[allow(clippy::suspicious_arithmetic_impl)]
    fn mul(self, rhs: Self) -> Self {
        if self.is_space() || rhs.is_space() {
            Char(' ')
        } else {
            self
        }
    }
}

fn main() -> std::io::Result<()> {

    // Vicsek rendered in numbers

    #[rustfmt::skip]
    let vicsek = Mat::<u8>::from_vec(vec![
        0, 1, 0,
        1, 1, 1,
        0, 1, 0,
    ], 3, 3);

    println!("{}", vicsek);
    println!("{}", kronecker::power(&vicsek, 3));

    // We could render something by mapping the numbers to
    // something else. But we could compute with something
    // else directly, right?
    let s = Char::space();
    let b = Char('\u{2588}');

    #[rustfmt::skip]
    let sierpienski = Mat::from_vec(vec![
        b, b, b,
        b, s, b,
        b, b, b,
    ], 3, 3);

    println!("{}", sierpienski);
    println!("{}", kronecker::power(&sierpienski, 3));

    #[rustfmt::skip]
    let matrix = Mat::from_vec(vec![
        s, s, b, s, s,
        s, b, b, b, s,
        b, s, b, s, b,
        s, s, b, s, s,
        s, b, s, b, s,
    ], 5, 5,);

    println!("{}", kronecker::power(&matrix, 1));

    // This is nicer as an actual image
    kronecker::power(&matrix, 4).write_ppm(
        &mut std::fs::OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open("kronecker_power.ppm")?,
        |&item| {
            if item.is_space() {
                (0, 0, 32)
            } else {
                (192, 192, 0)
            }
        },
    )
}

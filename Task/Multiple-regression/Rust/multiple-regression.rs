use std::fmt;

#[derive(Debug, Clone)]
struct Matrix<const R: usize, const C: usize> {
    data: [[f64; C]; R],
}

impl<const R: usize, const C: usize> Matrix<R, C> {
    fn new() -> Self {
        Self {
            data: [[0.0; C]; R],
        }
    }

    fn from_rows(values: &[&[f64]]) -> Self {
        let mut matrix = Self::new();
        for (i, row) in values.iter().enumerate().take(R) {
            for (j, &val) in row.iter().enumerate().take(C) {
                matrix.data[i][j] = val;
            }
        }
        matrix
    }

    fn get(&self, row: usize, col: usize) -> f64 {
        self.data[row][col]
    }

    fn set(&mut self, row: usize, col: usize, value: f64) {
        self.data[row][col] = value;
    }

    fn get_row(&self, row: usize) -> [f64; C] {
        self.data[row]
    }

    fn set_row(&mut self, row: usize, values: &[f64; C]) {
        self.data[row] = *values;
    }

    fn multiply<const D: usize>(&self, rhs: &Matrix<C, D>) -> Matrix<R, D> {
        let mut result = Matrix::<R, D>::new();
        for i in 0..R {
            for j in 0..D {
                for k in 0..C {
                    let prod = self.get(i, k) * rhs.get(k, j);
                    result.set(i, j, result.get(i, j) + prod);
                }
            }
        }
        result
    }

    fn transpose(&self) -> Matrix<C, R> {
        let mut trans = Matrix::<C, R>::new();
        for i in 0..R {
            for j in 0..C {
                trans.set(j, i, self.data[i][j]);
            }
        }
        trans
    }

    fn to_reduced_row_echelon_form(&mut self) {
        let mut lead = 0;
        for r in 0..R {
            if C <= lead {
                return;
            }
            let mut i = r;

            while self.get(i, lead) == 0.0 {
                i += 1;
                if R == i {
                    i = r;
                    lead += 1;
                    if C == lead {
                        return;
                    }
                }
            }

            // Swap rows
            let temp = self.get_row(i);
            self.set_row(i, &self.get_row(r));
            self.set_row(r, &temp);

            if self.get(r, lead) != 0.0 {
                let div = self.get(r, lead);
                for j in 0..C {
                    self.set(r, j, self.get(r, j) / div);
                }
            }

            for k in 0..R {
                if k != r {
                    let mult = self.get(k, lead);
                    for j in 0..C {
                        let prod = self.get(r, j) * mult;
                        self.set(k, j, self.get(k, j) - prod);
                    }
                }
            }

            lead += 1;
        }
    }
}

impl<const N: usize> Matrix<N, N> {
    fn inverse(&self) -> Result<Matrix<N, N>, &'static str> {
        if N == 0 {
            return Err("Cannot invert empty matrix");
        }

        // Create augmented matrix using Vec for dynamic sizing
        let mut aug = vec![vec![0.0; 2 * N]; N];

        // Copy original matrix to left side of augmented matrix
        for i in 0..N {
            for j in 0..N {
                aug[i][j] = self.get(i, j);
            }
            // Add identity matrix to right side
            aug[i][i + N] = 1.0;
        }

        // Perform Gauss-Jordan elimination
        let mut lead = 0;
        for r in 0..N {
            if 2 * N <= lead {
                return Err("Matrix is not invertible");
            }
            let mut i = r;

            while aug[i][lead] == 0.0 {
                i += 1;
                if N == i {
                    i = r;
                    lead += 1;
                    if 2 * N == lead {
                        return Err("Matrix is not invertible");
                    }
                }
            }

            // Swap rows
            aug.swap(i, r);

            if aug[r][lead] != 0.0 {
                let div = aug[r][lead];
                for j in 0..(2 * N) {
                    aug[r][j] /= div;
                }
            }

            for k in 0..N {
                if k != r {
                    let mult = aug[k][lead];
                    for j in 0..(2 * N) {
                        aug[k][j] -= aug[r][j] * mult;
                    }
                }
            }

            lead += 1;
        }

        // Extract inverse from right side
        let mut inv = Matrix::<N, N>::new();
        for i in 0..N {
            for j in 0..N {
                inv.set(i, j, aug[i][j + N]);
            }
        }
        Ok(inv)
    }
}

impl<const R: usize, const C: usize> fmt::Display for Matrix<R, C> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        for i in 0..R {
            write!(f, "[")?;
            for j in 0..C {
                if j > 0 {
                    write!(f, ", ")?;
                }
                write!(f, "{}", self.get(i, j))?;
            }
            writeln!(f, "]")?;
        }
        Ok(())
    }
}

fn multiple_regression<const R: usize, const C: usize>(
    y: &[f64; C],
    x: &Matrix<R, C>,
) -> Result<[f64; R], &'static str> {
    let mut tm = Matrix::<1, C>::new();
    for (i, &val) in y.iter().enumerate() {
        tm.set(0, i, val);
    }

    let cy = tm.transpose();
    let cx = x.transpose();
    let x_cx = x.multiply(&cx);
    let inv = x_cx.inverse()?;
    let result = inv.multiply(&x.multiply(&cy)).transpose();

    Ok(result.get_row(0))
}

fn case1() -> Result<(), &'static str> {
    let y = [1.0, 2.0, 3.0, 4.0, 5.0];
    let x = Matrix::<1, 5>::from_rows(&[&[2.0, 1.0, 3.0, 4.0, 5.0]]);
    let v = multiple_regression(&y, &x)?;
    println!("{:?}", v);
    Ok(())
}

fn case2() -> Result<(), &'static str> {
    let y = [3.0, 4.0, 5.0];
    let x = Matrix::<2, 3>::from_rows(&[
        &[1.0, 2.0, 1.0],
        &[1.0, 1.0, 2.0],
    ]);
    let v = multiple_regression(&y, &x)?;
    println!("{:?}", v);
    Ok(())
}

fn case3() -> Result<(), &'static str> {
    let y = [
        52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93, 61.29,
        63.11, 64.47, 66.28, 68.10, 69.92, 72.19, 74.46,
    ];
    let a = [
        1.47, 1.50, 1.52, 1.55, 1.57, 1.60, 1.63, 1.65,
        1.68, 1.70, 1.73, 1.75, 1.78, 1.80, 1.83,
    ];

    let mut x = Matrix::<3, 15>::new();

    // First row: all ones
    for i in 0..15 {
        x.set(0, i, 1.0);
    }

    // Second row: values from array 'a'
    for (i, &val) in a.iter().enumerate() {
        x.set(1, i, val);
    }

    // Third row: squared values from array 'a'
    for (i, &val) in a.iter().enumerate() {
        x.set(2, i, val * val);
    }

    let v = multiple_regression(&y, &x)?;
    println!("{:?}", v);
    Ok(())
}

fn main() -> Result<(), &'static str> {
    case1()?;
    case2()?;
    case3()?;
    Ok(())
}

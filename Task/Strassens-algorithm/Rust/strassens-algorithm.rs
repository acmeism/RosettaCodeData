use std::fmt;
use std::ops::{Add, Mul, Sub};

#[derive(Debug, Clone)]
struct Matrix {
    data: Vec<Vec<f64>>,
    rows: usize,
    cols: usize,
}

impl Matrix {
    fn new(data: Vec<Vec<f64>>) -> Self {
        let rows = data.len();
        let cols = if rows > 0 { data[0].len() } else { 0 };
        Matrix { data, rows, cols }
    }

    fn rows(&self) -> usize {
        self.rows
    }

    fn cols(&self) -> usize {
        self.cols
    }

    fn validate_dimensions(&self, other: &Matrix) {
        if self.rows() != other.rows() || self.cols() != other.cols() {
            panic!("Matrices must have the same dimensions.");
        }
    }

    fn validate_multiplication(&self, other: &Matrix) {
        if self.cols() != other.rows() {
            panic!("Cannot multiply these matrices.");
        }
    }

    fn validate_square_power_of_two(&self) {
        if self.rows() != self.cols() {
            panic!("Matrix must be square.");
        }
        if self.rows() == 0 || (self.rows() & (self.rows() - 1)) != 0 {
            panic!("Size of matrix must be a power of two.");
        }
    }
}

impl Add for Matrix {
    type Output = Self;

    fn add(self, other: Self) -> Self {
        self.validate_dimensions(&other);

        let mut result_data = Vec::with_capacity(self.rows());
        for i in 0..self.rows() {
            let mut row = Vec::with_capacity(self.cols());
            for j in 0..self.cols() {
                row.push(self.data[i][j] + other.data[i][j]);
            }
            result_data.push(row);
        }

        Matrix::new(result_data)
    }
}

impl Sub for Matrix {
    type Output = Self;

    fn sub(self, other: Self) -> Self {
        self.validate_dimensions(&other);

        let mut result_data = Vec::with_capacity(self.rows());
        for i in 0..self.rows() {
            let mut row = Vec::with_capacity(self.cols());
            for j in 0..self.cols() {
                row.push(self.data[i][j] - other.data[i][j]);
            }
            result_data.push(row);
        }

        Matrix::new(result_data)
    }
}

impl Mul for Matrix {
    type Output = Self;

    fn mul(self, other: Self) -> Self {
        self.validate_multiplication(&other);

        let mut result_data = Vec::with_capacity(self.rows());
        for i in 0..self.rows() {
            let mut row = Vec::with_capacity(other.cols());
            for j in 0..other.cols() {
                let mut sum = 0.0;
                for k in 0..other.rows() {
                    sum += self.data[i][k] * other.data[k][j];
                }
                row.push(sum);
            }
            result_data.push(row);
        }

        Matrix::new(result_data)
    }
}

impl fmt::Display for Matrix {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let mut s = String::new();
        for row in &self.data {
            s.push_str(&format!("{:?}\n", row));
        }
        write!(f, "{}", s)
    }
}

impl Matrix {
    fn to_string_with_precision(&self, p: usize) -> String {
        let mut s = String::new();
        let pow = 10.0_f64.powi(p as i32);
        for row in &self.data {
            let mut t = Vec::new();
            for &val in row {
                let r = (val * pow).round() / pow;
                let formatted = format!("{}", r);
                if formatted == "-0" {
                    t.push("0".to_string());
                } else {
                    t.push(formatted);
                }
            }
            s.push_str(&format!("{:?}\n", t));
        }
        s
    }

    fn params(r: usize, c: usize) -> [[usize; 6]; 4] {
        [
            [0, r, 0, c, 0, 0],
            [0, r, c, 2 * c, 0, c],
            [r, 2 * r, 0, c, r, 0],
            [r, 2 * r, c, 2 * c, r, c],
        ]
    }

    fn to_quarters(&self) -> [Matrix; 4] {
        let r = self.rows() / 2;
        let c = self.cols() / 2;
        let p = Matrix::params(r, c);
        let mut quarters: [Matrix; 4] = [
            Matrix::new(vec![vec![0.0; c]; r]),
            Matrix::new(vec![vec![0.0; c]; r]),
            Matrix::new(vec![vec![0.0; c]; r]),
            Matrix::new(vec![vec![0.0; c]; r]),
        ];

        for k in 0..4 {
            let mut q_data = Vec::with_capacity(r);
            for i in p[k][0]..p[k][1] {
                let mut row = Vec::with_capacity(c);
                for j in p[k][2]..p[k][3] {
                    row.push(self.data[i][j]);
                }
                q_data.push(row);
            }
            quarters[k] = Matrix::new(q_data);
        }

        quarters
    }

    fn from_quarters(q: [Matrix; 4]) -> Matrix {
        let r = q[0].rows();
        let c = q[0].cols();
        let p = Matrix::params(r, c);
        let rows = r * 2;
        let cols = c * 2;

        let mut m_data = vec![vec![0.0; cols]; rows];

        for k in 0..4 {
            for i in p[k][0]..p[k][1] {
                for j in p[k][2]..p[k][3] {
                    m_data[i][j] = q[k].data[i - p[k][4]][j - p[k][5]];
                }
            }
        }

        Matrix::new(m_data)
    }

    fn strassen(&self, other: Matrix) -> Matrix {
        self.validate_square_power_of_two();
        other.validate_square_power_of_two();
        if self.rows() != other.rows() || self.cols() != other.cols() {
            panic!("Matrices must be square and of equal size for Strassen multiplication.");
        }

        if self.rows() == 1 {
            return self.clone() * other;
        }

        let qa = self.to_quarters();
        let qb = other.to_quarters();

        let p1 = (qa[1].clone() - qa[3].clone()).strassen(qb[2].clone() + qb[3].clone());
        let p2 = (qa[0].clone() + qa[3].clone()).strassen(qb[0].clone() + qb[3].clone());
        let p3 = (qa[0].clone() - qa[2].clone()).strassen(qb[0].clone() + qb[1].clone());
        let p4 = (qa[0].clone() + qa[1].clone()).strassen(qb[3].clone());
        let p5 = qa[0].clone().strassen(qb[1].clone() - qb[3].clone());
        let p6 = qa[3].clone().strassen(qb[2].clone() - qb[0].clone());
        let p7 = (qa[2].clone() + qa[3].clone()).strassen(qb[0].clone());

        let mut q: [Matrix; 4] = [
            Matrix::new(vec![vec![0.0; qa[0].cols()]; qa[0].rows()]),
            Matrix::new(vec![vec![0.0; qa[0].cols()]; qa[0].rows()]),
            Matrix::new(vec![vec![0.0; qa[0].cols()]; qa[0].rows()]),
            Matrix::new(vec![vec![0.0; qa[0].cols()]; qa[0].rows()]),
        ];

        q[0] = p1.clone() + p2.clone() - p4.clone() + p6.clone();
        q[1] = p4 + p5.clone();
        q[2] = p6 + p7.clone();
        q[3] = p2 - p3.clone() + p5 - p7;

        Matrix::from_quarters(q)
    }
}

fn main() {
    let a = Matrix::new(vec![vec![1.0, 2.0], vec![3.0, 4.0]]);
    let b = Matrix::new(vec![vec![5.0, 6.0], vec![7.0, 8.0]]);
    let c = Matrix::new(vec![
        vec![1.0, 1.0, 1.0, 1.0],
        vec![2.0, 4.0, 8.0, 16.0],
        vec![3.0, 9.0, 27.0, 81.0],
        vec![4.0, 16.0, 64.0, 256.0],
    ]);
    let d = Matrix::new(vec![
        vec![4.0, -3.0, 4.0 / 3.0, -1.0 / 4.0],
        vec![-13.0 / 3.0, 19.0 / 4.0, -7.0 / 3.0, 11.0 / 24.0],
        vec![3.0 / 2.0, -2.0, 7.0 / 6.0, -1.0 / 4.0],
        vec![-1.0 / 6.0, 1.0 / 4.0, -1.0 / 6.0, 1.0 / 24.0],
    ]);
    let e = Matrix::new(vec![
        vec![1.0, 2.0, 3.0, 4.0],
        vec![5.0, 6.0, 7.0, 8.0],
        vec![9.0, 10.0, 11.0, 12.0],
        vec![13.0, 14.0, 15.0, 16.0],
    ]);
    let f = Matrix::new(vec![
        vec![1.0, 0.0, 0.0, 0.0],
        vec![0.0, 1.0, 0.0, 0.0],
        vec![0.0, 0.0, 1.0, 0.0],
        vec![0.0, 0.0, 0.0, 1.0],
    ]);

    println!("Using 'normal' matrix multiplication:");
    println!("  a * b = {}", a.clone() * b.clone());
    println!("  c * d = {}", (c.clone() * d.clone()).to_string_with_precision(6));
    println!("  e * f = {}", e.clone() * f.clone());

    println!("\nUsing 'Strassen' matrix multiplication:");
    println!("  a * b = {}", a.strassen(b));
    println!("  c * d = {}", c.strassen(d).to_string_with_precision(6));
    println!("  e * f = {}", e.strassen(f));
}

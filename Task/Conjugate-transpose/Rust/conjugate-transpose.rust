extern crate num; // crate for complex numbers

use num::complex::Complex;
use std::ops::Mul;
use std::fmt;


#[derive(Debug, PartialEq)]
struct Matrix<f32> {
    grid: [[Complex<f32>; 2]; 2], // used to represent matrix
}


impl Matrix<f32> { // implements a method call for calculating the conjugate transpose
    fn conjugate_transpose(&self) -> Matrix<f32> {
        Matrix {grid: [[self.grid[0][0].conj(), self.grid[1][0].conj()],
        [self.grid[0][1].conj(), self.grid[1][1].conj()]]}
    }
}

impl Mul for Matrix<f32> { // implements '*' (multiplication) for the matrix
    type Output = Matrix<f32>;

    fn mul(self, other: Matrix<f32>) -> Matrix<f32> {
        Matrix {grid: [[self.grid[0][0]*other.grid[0][0] + self.grid[0][1]*other.grid[1][0],
            self.grid[0][0]*other.grid[0][1] + self.grid[0][1]*other.grid[1][1]],
            [self.grid[1][0]*other.grid[0][0] + self.grid[1][1]*other.grid[1][0],
            self.grid[1][0]*other.grid[1][0] + self.grid[1][1]*other.grid[1][1]]]}
    }
}

impl Copy for Matrix<f32> {} // implemented to prevent 'moved value' errors in if statements below
impl Clone for Matrix<f32> {
    fn clone(&self) -> Matrix<f32> {
        *self
    }
}

impl fmt::Display for Matrix<f32> { // implemented to make output nicer
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "({}, {})\n({}, {})", self.grid[0][0], self.grid[0][1], self.grid[1][0], self.grid[1][1])
    }
}

fn main() {
    let a = Matrix {grid: [[Complex::new(3.0, 0.0), Complex::new(2.0, 1.0)],
        [Complex::new(2.0, -1.0), Complex::new(1.0, 0.0)]]};

    let b = Matrix {grid: [[Complex::new(0.5, 0.5), Complex::new(0.5, -0.5)],
        [Complex::new(0.5, -0.5), Complex::new(0.5, 0.5)]]};

    test_type(a);
    test_type(b);
}

fn test_type(mat: Matrix<f32>) {
    let identity = Matrix {grid: [[Complex::new(1.0, 0.0), Complex::new(0.0, 0.0)],
        [Complex::new(0.0, 0.0), Complex::new(1.0, 0.0)]]};
    let mat_conj = mat.conjugate_transpose();

    println!("Matrix: \n{}\nConjugate transpose: \n{}", mat, mat_conj);

    if mat == mat_conj {
        println!("Hermitian?: TRUE");
    } else {
        println!("Hermitian?: FALSE");
    }

    if mat*mat_conj == mat_conj*mat {
        println!("Normal?: TRUE");
    } else {
        println!("Normal?: FALSE");
    }

    if mat*mat_conj == identity {
        println!("Unitary?: TRUE");
    } else {
        println!("Unitary?: FALSE");
    }
}

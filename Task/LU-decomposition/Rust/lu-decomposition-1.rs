#![allow(non_snake_case)]
use ndarray::{Array, Axis, Array2, arr2, Zip, NdFloat, s};

fn main() {
    println!("Example 1:");
    let A: Array2<f64> = arr2(&[
        [1.0, 3.0, 5.0],
        [2.0, 4.0, 7.0],
        [1.0, 1.0, 0.0],
    ]);
    println!("A \n {}", A);
    let (L, U, P) = lu_decomp(A);
    println!("L \n {}", L);
    println!("U \n {}", U);
    println!("P \n {}", P);

    println!("\nExample 2:");
    let A: Array2<f64> = arr2(&[
        [11.0, 9.0, 24.0, 2.0],
        [1.0, 5.0, 2.0, 6.0],
        [3.0, 17.0, 18.0, 1.0],
        [2.0, 5.0, 7.0, 1.0],
    ]);
    println!("A \n {}", A);
    let (L, U, P) = lu_decomp(A);
    println!("L \n {}", L);
    println!("U \n {}", U);
    println!("P \n {}", P);
}

fn pivot<T>(A: &Array2<T>) -> Array2<T>
where T: NdFloat {
    let matrix_dimension = A.rows();
    let mut P: Array2<T> = Array::eye(matrix_dimension);
    for (i, column) in A.axis_iter(Axis(1)).enumerate() {
        // find idx of maximum value in column i
        let mut max_pos = i;
        for j in i..matrix_dimension {
            if column[max_pos].abs() < column[j].abs() {
                max_pos = j;
            }
        }
        // swap rows of P if necessary
        if max_pos != i {
            swap_rows(&mut P, i, max_pos);
        }
    }
    P
}

fn swap_rows<T>(A: &mut Array2<T>, idx_row1: usize, idx_row2: usize)
where T: NdFloat {
    // to swap rows, get two ArrayViewMuts for the corresponding rows
    // and apply swap elementwise using ndarray::Zip
    let (.., mut matrix_rest) = A.view_mut().split_at(Axis(0), idx_row1);
    let (row0, mut matrix_rest) = matrix_rest.view_mut().split_at(Axis(0), 1);
    let (_matrix_helper, mut matrix_rest) = matrix_rest.view_mut().split_at(Axis(0), idx_row2 - idx_row1 - 1);
    let (row1, ..) = matrix_rest.view_mut().split_at(Axis(0), 1);
    Zip::from(row0).and(row1).apply(std::mem::swap);
}

fn lu_decomp<T>(A: Array2<T>) -> (Array2<T>, Array2<T>, Array2<T>)
where T: NdFloat {

    let matrix_dimension = A.rows();
    assert_eq!(matrix_dimension, A.cols(), "Tried LU decomposition with a non-square matrix.");
    let P = pivot(&A);
    let pivotized_A = P.dot(&A);

    let mut L: Array2<T> = Array::eye(matrix_dimension);
    let mut U: Array2<T> = Array::zeros((matrix_dimension, matrix_dimension));
    for idx_col in 0..matrix_dimension {
        // fill U
        for idx_row in 0..idx_col+1 {
            U[[idx_row, idx_col]] = pivotized_A[[idx_row, idx_col]] -
                U.slice(s![0..idx_row,idx_col]).dot(&L.slice(s![idx_row,0..idx_row]));
        }
        // fill L
        for idx_row in idx_col+1..matrix_dimension {
            L[[idx_row, idx_col]] = (pivotized_A[[idx_row, idx_col]] -
                U.slice(s![0..idx_col,idx_col]).dot(&L.slice(s![idx_row,0..idx_col]))) /
                U[[idx_col, idx_col]];
        }
    }
    (L, U, P)
}

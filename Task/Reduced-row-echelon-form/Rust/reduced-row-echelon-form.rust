fn main() {
    let mut matrix_to_reduce: Vec<Vec<f64>> = vec![vec![1.0, 2.0 , -1.0, -4.0],
                                                vec![2.0, 3.0, -1.0, -11.0],
                                                vec![-2.0, 0.0, -3.0, 22.0]];
    let mut r_mat_to_red = &mut matrix_to_reduce;
    let rr_mat_to_red = &mut r_mat_to_red;

    println!("Matrix to reduce:\n{:?}", rr_mat_to_red);
    let reduced_matrix = reduced_row_echelon_form(rr_mat_to_red);
    println!("Reduced matrix:\n{:?}", reduced_matrix);
}

fn reduced_row_echelon_form(matrix: &mut Vec<Vec<f64>>) -> Vec<Vec<f64>> {
    let mut matrix_out: Vec<Vec<f64>> = matrix.to_vec();
    let mut pivot = 0;
    let row_count = matrix_out.len();
    let column_count = matrix_out[0].len();

    'outer: for r in 0..row_count {
        if column_count <= pivot {
            break;
        }
        let mut i = r;
        while matrix_out[i][pivot] == 0.0 {
            i = i+1;
            if i == row_count {
                i = r;
                pivot = pivot + 1;
                if column_count == pivot {
                    pivot = pivot - 1;
                    break 'outer;
                }
            }
        }
        for j in 0..row_count {
            let temp = matrix_out[r][j];
            matrix_out[r][j] = matrix_out[i][j];
            matrix_out[i][j] = temp;
        }
        let divisor = matrix_out[r][pivot];
        if divisor != 0.0 {
            for j in 0..column_count {
                matrix_out[r][j] = matrix_out[r][j] / divisor;
            }
        }
        for j in 0..row_count {
            if j != r {
                let hold = matrix_out[j][pivot];
                for k in 0..column_count {
                    matrix_out[j][k] = matrix_out[j][k] - ( hold * matrix_out[r][k]);
                }
            }
        }
        pivot = pivot + 1;
    }
    matrix_out
}

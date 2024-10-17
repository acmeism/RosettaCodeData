fn main() {
    let mut a: Vec<Vec<f64>> = vec![vec![1.0, 2.0, 3.0],
                                vec![4.0, 1.0, 6.0],
                                vec![7.0, 8.0, 9.0]
                                ];
    let mut b: Vec<Vec<f64>> = vec![vec![2.0, -1.0, 0.0],
                                vec![-1.0, 2.0, -1.0],
                                vec![0.0, -1.0, 2.0]
                                ];

    let mut ref_a = &mut a;
    let rref_a = &mut ref_a;
    let mut ref_b = &mut b;
    let rref_b = &mut ref_b;

    println!("Matrix A:\n");
    print_matrix(rref_a);
    println!("\nInverse of Matrix A:\n");
    print_matrix(&mut matrix_inverse(rref_a));
    println!("\n\nMatrix B:\n");
    print_matrix(rref_b);
    println!("\nInverse of Matrix B:\n");
    print_matrix(&mut matrix_inverse(rref_b));
}

//Begin Matrix Inversion
fn matrix_inverse(matrix: &mut Vec<Vec<f64>>) -> Vec<Vec<f64>>{
    let len = matrix.len();
    let mut aug = zero_matrix(len, len * 2);
    for i in 0..len {
        for j in 0.. len {
            aug[i][j] = matrix[i][j];
        }
        aug[i][i + len] = 1.0;
    }

    gauss_jordan_general(&mut aug);


    let mut unaug = zero_matrix(len, len);
    for i in 0..len {
        for j in 0..len {
            unaug[i][j] = aug[i][j+len];
        }
    }
    unaug
}
//End Matrix Inversion

//Begin Generalised Reduced Row Echelon Form
fn gauss_jordan_general(matrix: &mut Vec<Vec<f64>>) {
    let mut lead = 0;
    let row_count = matrix.len();
    let col_count = matrix[0].len();

    for r in 0..row_count {
        if col_count <= lead {
            break;
        }
        let mut i = r;
        while matrix[i][lead] == 0.0 {
            i = i + 1;
            if row_count == i {
                i = r;
                lead = lead + 1;
                if col_count == lead {
                    break;
                }
            }
        }

        let temp = matrix[i].to_owned();
        matrix[i] = matrix[r].to_owned();
        matrix[r] = temp.to_owned();

        if matrix[r][lead] != 0.0 {
            let div = matrix[r][lead];
            for j in 0..col_count {
                matrix[r][j] = matrix[r][j] / div;
            }
        }

        for k in 0..row_count {
            if k != r {
                let mult = matrix[k][lead];
                for j in 0..col_count {
                    matrix[k][j] = matrix[k][j] - matrix[r][j] * mult;
                }
            }
        }
        lead = lead + 1;

    }
    //matrix.to_owned()
}

fn zero_matrix(rows: usize, cols: usize) -> Vec<Vec<f64>> {
    let mut matrix = Vec::with_capacity(cols);
    for _ in 0..rows {
        let mut col: Vec<f64> = Vec::with_capacity(rows);
        for _ in 0..cols {
            col.push(0.0);
        }
        matrix.push(col);
    }
    matrix
}

fn print_matrix(mat: &mut Vec<Vec<f64>>) {
    for row in 0..mat.len(){
        println!("{:?}", mat[row]);
    }
}

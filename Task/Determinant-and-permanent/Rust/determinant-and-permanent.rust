fn main() {
let mut m1: Vec<Vec<f64>> = vec![vec![1.0,2.0],vec![3.0,4.0]];
    let mut r_m1 = &mut m1;
    let rr_m1 = &mut r_m1;
    let mut m2: Vec<Vec<f64>> = vec![vec![1.0, 2.0, 3.0, 4.0], vec![4.0, 5.0, 6.0, 7.0], vec![7.0, 8.0, 9.0, 10.0], vec![10.0, 11.0, 12.0, 13.0]];
    let mut r_m2 = &mut m2;
    let rr_m2 = &mut r_m2;
    let mut m3: Vec<Vec<f64>> = vec![vec![0.0, 1.0, 2.0, 3.0, 4.0],
                                vec![5.0, 6.0, 7.0, 8.0, 9.0],
                                vec![10.0, 11.0, 12.0, 13.0, 14.0],
                                vec![15.0, 16.0, 17.0, 18.0, 19.0],
                                vec![20.0, 21.0, 22.0, 23.0, 24.0]];
    let mut r_m3 = &mut m3;
    let rr_m3 = &mut r_m3;

    println!("Determinant of m1: {}", determinant(rr_m1));
    println!("Permanent of m1: {}", permanent(rr_m1));

    println!("Determinant of m2: {}", determinant(rr_m2));
    println!("Permanent of m2: {}", permanent(rr_m2));

    println!("Determinant of m3: {}", determinant(rr_m3));
    println!("Permanent of m3: {}", permanent(rr_m3));

}

fn minor( a: &mut Vec<Vec<f64>>, x: usize, y: usize) ->  Vec<Vec<f64>> {
    let mut out_vec: Vec<Vec<f64>> = vec![vec![0.0; a.len() - 1]; a.len() -1];
    for i in 0..a.len()-1 {
        for j in 0..a.len()-1 {
            match () {
                _ if (i < x && j < y) => {
                    out_vec[i][j] = a[i][j];
                },
                _ if (i >= x && j < y) => {
                    out_vec[i][j] = a[i + 1][j];
                },
                _ if (i < x && j >= y) => {
                    out_vec[i][j] = a[i][j + 1];
                },
                _ => { //i > x && j > y
                    out_vec[i][j] = a[i + 1][j + 1];
                },
            }
        }
    }
    out_vec
}

fn determinant (matrix: &mut Vec<Vec<f64>>) -> f64 {
    match () {
        _ if (matrix.len() == 1) => {
            matrix[0][0]
        },
        _ => {
            let mut sign = 1.0;
            let mut sum = 0.0;
            for i in 0..matrix.len() {
                sum = sum + sign * matrix[0][i] * determinant(&mut minor(matrix, 0, i));
                sign = sign * -1.0;
            }
            sum
        }
    }
}

fn permanent (matrix: &mut Vec<Vec<f64>>) -> f64 {
    match () {
        _ if (matrix.len() == 1) => {
            matrix[0][0]
        },
        _ => {
            let mut sum = 0.0;
            for i in 0..matrix.len() {
                sum = sum + matrix[0][i] * permanent(&mut minor(matrix, 0, i));
            }
            sum
        }
    }
}

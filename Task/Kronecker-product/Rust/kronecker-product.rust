fn main() {

    let mut a = vec![vec![1., 2.], vec![3., 4.]];
    let mut b = vec![vec![0., 5.], vec![6., 7.]];

    let mut a_ref = &mut a;
    let a_rref = &mut a_ref;

    let mut b_ref = &mut b;
    let b_rref = &mut b_ref;

    let ab = kronecker_product(a_rref, b_rref);

    println!("Kronecker product of\n");
    for i in a {
        println!("{:?}", i);
    }
    println!("\nand\n");
    for i in b {
        println!("{:?}", i);
    }
    println!("\nis\n");
    for i in ab {
        println!("{:?}", i);
    }

    println!("\n\n");

    let mut a = vec![vec![0., 1., 0.],
                    vec![1., 1., 1.],
                    vec![0., 1., 0.]];
    let mut b = vec![vec![1., 1., 1., 1.],
                    vec![1., 0., 0., 1.],
                    vec![1., 1., 1., 1.]];

    let mut a_ref = &mut a;
    let a_rref = &mut a_ref;

    let mut b_ref = &mut b;
    let b_rref = &mut b_ref;

    let ab = kronecker_product(a_rref, b_rref);

    println!("Kronecker product of\n");
    for i in a {
        println!("{:?}", i);
    }
    println!("\nand\n");
    for i in b {
        println!("{:?}", i);
    }
    println!("\nis\n");
    for i in ab {
        println!("{:?}", i);
    }

    println!("\n\n");

}

fn kronecker_product(a: &mut Vec<Vec<f64>>, b: &mut Vec<Vec<f64>>) -> Vec<Vec<f64>> {
    let m = a.len();
    let n = a[0].len();
    let p = b.len();
    let q = b[0].len();
    let rtn = m * p;
    let ctn = n * q;

    let mut r = zero_matrix(rtn, ctn);

    for i in 0..m {
        for j in 0..n {
            for k in 0..p {
                for l in 0..q {
                    r[p * i + k][q * j + l] = a[i][j] * b[k][l];
                }
            }
        }
    }
    r
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

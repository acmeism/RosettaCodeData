use std::fmt;

#[derive(Debug, Clone, Copy, PartialEq)]
enum Faffian {
    Pfaffian,
    Hfaffian,
}

impl fmt::Display for Faffian {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Faffian::Pfaffian => write!(f, "Pfaffian"),
            Faffian::Hfaffian => write!(f, "Hfaffain"),
        }
    }
}

#[derive(Debug, Clone)]
struct SignedPerm {
    permutation: Vec<u32>,
    sign: i32,
}

impl SignedPerm {
    fn new(permutation: Vec<u32>, sign: i32) -> Self {
        Self { permutation, sign }
    }
}

fn print_matrix(matrix: &[Vec<i32>]) {
    for row in matrix {
        print!("|");
        for (i, &val) in row.iter().enumerate() {
            if i < row.len() - 1 {
                print!("{:2}, ", val);
            } else {
                print!("{:2}", val);
            }
        }
        println!("|");
    }
}

fn factorial(n: u32) -> u32 {
    (1..=n).product()
}

fn is_antisymmetric(matrix: &[Vec<i32>]) -> bool {
    for i in 0..matrix.len() {
        if matrix[i][i] != 0 {
            return false;
        }
        for j in (i + 1)..matrix.len() {
            if matrix[i][j] != -matrix[j][i] {
                return false;
            }
        }
    }
    true
}

fn signed_permutations(n: u32) -> Vec<SignedPerm> {
    let mut perms: Vec<u32> = (0..=n).collect();
    let mut signed_perms = vec![SignedPerm::new(perms.clone(), 1)];
    let mut sign = 1i32;

    for _ in 1..factorial(n + 1) {
        let mut i = n as usize - 1;
        let mut j = n as usize;

        while perms[i] > perms[i + 1] {
            i -= 1;
        }

        while perms[j] < perms[i] {
            j -= 1;
        }

        perms.swap(i, j);
        sign = -sign;

        i += 1;
        j = n as usize;

        while i < j {
            perms.swap(i, j);
            sign = -sign;
            i += 1;
            j -= 1;
        }

        signed_perms.push(SignedPerm::new(perms.clone(), sign));
    }

    signed_perms
}

fn compute_faffian(matrix: &[Vec<i32>], faffian: Faffian) -> Option<i32> {
    if matrix.len() % 2 != 0 {
        println!("Matrix size must be even for {}", faffian);
        return None;
    }

    if !is_antisymmetric(matrix) {
        println!("The {} does not support non-antisymmetric matrices", faffian);
        return None;
    }

    let n = matrix.len() / 2;
    let mut sum = 0i32;
    let signed_perms = signed_permutations(2 * n as u32 - 1);

    for signed_perm in signed_perms {
        let sigma = &signed_perm.permutation;
        let sign = if faffian == Faffian::Pfaffian {
            signed_perm.sign
        } else {
            1
        };

        let mut product = 1i32;
        for i in 0..n {
            product *= matrix[sigma[2 * i] as usize][sigma[2 * i + 1] as usize];
        }
        sum += sign * product;
    }

    let normalisation = 1.0 / factorial(n as u32) as f64 / 2.0_f64.powi(n as i32);
    Some((sum as f64 * normalisation).round() as i32)
}

fn main() {
    let matrices = vec![
        vec![
            vec![0, 1],
            vec![-1, 0]
        ], // Tiny 2 x 2 matrix

        vec![
            vec![0, 1, -1, 2],
            vec![-1, 0, 3, -4],
            vec![1, -3, 0, 5],
            vec![-2, 4, -5, 0]
        ], // Small 4 x 4 matrix

        vec![
            vec![1, 2, 3, 4, 5, 6],
            vec![2, 7, 8, 9, 10, 11],
            vec![3, 8, 12, 13, 14, 15],
            vec![4, 9, 13, 16, 17, 18],
            vec![5, 10, 14, 17, 19, 20],
            vec![6, 11, 15, 18, 20, 21]
        ], // Symmetric 6 x 6 matrix

        vec![
            vec![0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
            vec![-1, 0, 8, 7, 6, 5, 4, 3, 2, 1],
            vec![-2, -8, 0, 1, 2, 3, 4, 5, 6, 7],
            vec![-3, -7, -1, 0, 6, 5, 4, 3, 2, 1],
            vec![-4, -6, -2, -6, 0, 1, 2, 3, 4, 5],
            vec![-5, -5, -3, -5, -1, 0, 4, 3, 2, 1],
            vec![-6, -4, -4, -4, -2, -4, 0, 1, 2, 3],
            vec![-7, -3, -5, -3, -3, -3, -1, 0, 2, 1],
            vec![-8, -2, -6, -2, -4, -2, -2, -2, 0, 1],
            vec![-9, -1, -7, -1, -5, -1, -3, -1, -1, 0]
        ] // Larger 10 x 10 matrix
    ];

    for matrix in &matrices {
        print_matrix(matrix);
        for faffian in [Faffian::Pfaffian, Faffian::Hfaffian] {
            if let Some(result) = compute_faffian(matrix, faffian) {
                println!("{}: {}", faffian, result);
            }
        }
        println!();
    }
}

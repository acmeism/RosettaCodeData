 use rand::thread_rng;
// use rand_0_8_5::thread_rng;
use std::collections::HashMap;
use std::time::Instant;
use rand::prelude::*;

fn print_one_based_vector(list: &[i32]) {
    print!("[");
    for i in 0..list.len() - 1 {
        print!("{}, ", list[i] + 1);
    }
    print!("{}]", list[list.len() - 1] + 1);
}

fn print_2d_vector(lists: &[Vec<i32>]) {
    print!("[");
    for i in 0..lists.len() - 1 {
        print_one_based_vector(&lists[i]);
        print!(", ");
    }
    print_one_based_vector(&lists[lists.len() - 1]);
    print!("]");
}

fn create_cube(matrix: &[Vec<i32>], size: usize) -> Vec<Vec<Vec<i32>>> {
    let mut cube = vec![vec![vec![0; size]; size]; size];

    for i in 0..size {
        for j in 0..size {
            let k = if matrix.is_empty() {
                (i + j) % size
            } else {
                (matrix[i][j] - 1) as usize
            };
            cube[i][j][k] = 1;
        }
    }

    cube
}

fn shuffle_cube(cube: &mut Vec<Vec<Vec<i32>>>, rng: &mut ThreadRng) {
    let mut proper = true;
    let size = cube.len();

    // Find a random zero position
    let mut rx: usize;
    let mut ry: usize;
    let mut rz: usize;

    loop {
        rx = rng.gen_range(0..size);
        ry = rng.gen_range(0..size);
        rz = rng.gen_range(0..size);
        if cube[rx][ry][rz] == 0 {
            break;
        }
    }

    loop {
        let mut ox = 0;
        let mut oy = 0;
        let mut oz = 0;

        // Find the 1s in the same planes
        while cube[ox][ry][rz] != 1 {
            ox += 1;
        }
        while cube[rx][oy][rz] != 1 {
            oy += 1;
        }
        while cube[rx][ry][oz] != 1 {
            oz += 1;
        }

        if !proper {
            if rng.gen_bool(0.5) {
                ox += 1;
                while cube[ox][ry][rz] != 1 {
                    ox += 1;
                }
            }
            if rng.gen_bool(0.5) {
                oy += 1;
                while cube[rx][oy][rz] != 1 {
                    oy += 1;
                }
            }
            if rng.gen_bool(0.5) {
                oz += 1;
                while cube[rx][ry][oz] != 1 {
                    oz += 1;
                }
            }
        }

        // Perform the shuffle operation
        cube[rx][ry][rz] += 1;
        cube[rx][oy][oz] += 1;
        cube[ox][ry][oz] += 1;
        cube[ox][oy][rz] += 1;

        cube[rx][ry][oz] -= 1;
        cube[rx][oy][rz] -= 1;
        cube[ox][ry][rz] -= 1;
        cube[ox][oy][oz] -= 1;

        if cube[ox][oy][oz] < 0 {
            rx = ox;
            ry = oy;
            rz = oz;
            proper = false;
        } else {
            break;
        }
    }
}

fn to_matrix(cube: &[Vec<Vec<i32>>]) -> Vec<Vec<i32>> {
    let size = cube.len();
    let mut matrix = vec![vec![0; size]; size];

    for i in 0..size {
        for j in 0..size {
            for k in 0..size {
                if cube[i][j][k] != 0 {
                    matrix[i][j] = k as i32;
                    break;
                }
            }
        }
    }

    matrix
}

fn reduce(matrix: &mut [Vec<i32>]) {
    let size = matrix.len();

    // Normalize first row
    for j in 0..size - 1 {
        if matrix[0][j] != j as i32 {
            for k in j + 1..size {
                if matrix[0][k] == j as i32 {
                    for i in 0..size {
                        matrix[i].swap(j, k);
                    }
                    break;
                }
            }
        }
    }

    // Normalize first column
    for i in 1..size - 1 {
        if matrix[i][0] != i as i32 {
            for k in i + 1..size {
                if matrix[k][0] == i as i32 {
                    matrix.swap(i, k);
                    break;
                }
            }
        }
    }
}

fn main() {
    let mut rng = thread_rng();

    println!("PART 1: 10,000 latin Squares of order 4 in reduced form:\n");

    let original_4 = vec![
        vec![1, 2, 3, 4],
        vec![2, 1, 4, 3],
        vec![3, 4, 1, 2],
        vec![4, 3, 2, 1],
    ];

    let mut frequencies: HashMap<Vec<Vec<i32>>, u32> = HashMap::new();
    let mut cube = create_cube(&original_4, 4);

    for _ in 1..=10_000 {
        shuffle_cube(&mut cube, &mut rng);
        let mut matrix = to_matrix(&cube);
        reduce(&mut matrix);
        *frequencies.entry(matrix).or_insert(0) += 1;
    }

    for (matrix, count) in &frequencies {
        print_2d_vector(matrix);
        println!(" occurs {} times", count);
    }

    println!("\nPART 2: 10_000 latin squares of order 5 in reduced form:");

    let original_5 = vec![
        vec![1, 2, 3, 4, 5],
        vec![2, 3, 4, 5, 1],
        vec![3, 4, 5, 1, 2],
        vec![4, 5, 1, 2, 3],
        vec![5, 1, 2, 3, 4],
    ];

    frequencies.clear();
    cube = create_cube(&original_5, 5);

    for _ in 1..=10_000 {
        shuffle_cube(&mut cube, &mut rng);
        let mut matrix = to_matrix(&cube);
        reduce(&mut matrix);
        *frequencies.entry(matrix).or_insert(0) += 1;
    }

    let mut count = 0;
    for (_, freq) in &frequencies {
        count += 1;
        print!("{}{}{:2}({:3})",
               if count > 1 { ", " } else { "" },
               if count % 8 == 1 { "\n" } else { "" },
               count,
               freq);
    }

    println!("\n\nPART 3: 750 latin squares of order 42, showing the last one:\n");

    let matrix_42: Vec<Vec<i32>> = vec![];
    cube = create_cube(&matrix_42, 42);
    let mut final_matrix = vec![];

    for i in 1..=750 {
        shuffle_cube(&mut cube, &mut rng);
        if i == 750 {
            final_matrix = to_matrix(&cube);
        }
    }

    for row in &final_matrix {
        print_one_based_vector(row);
        println!();
    }

    println!("\nPART 4: 1,000 latin squares of order 256:\n");

    let start = Instant::now();
    let empty: Vec<Vec<i32>> = vec![];
    cube = create_cube(&empty, 256);

    for _ in 1..=1_000 {
        shuffle_cube(&mut cube, &mut rng);
    }

    let duration = start.elapsed();
    println!("Generated in {:.3} milliseconds", duration.as_secs_f64() * 1000.0);
}

// Add to Cargo.toml:
// [dependencies]
// rand = "0.8"

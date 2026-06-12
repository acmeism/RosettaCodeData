fn display(matrix: &Vec<Vec<i32>>) {
    for row in matrix {
        for element in row {
            print!("{:3}", element);
        }
        println!();
    }
    println!();
}

fn sign_change_count(row: &Vec<i32>) -> u32 {
    let mut sign_changes = 0;
    for i in 1..row.len() {
        if row[i - 1] == -row[i] {
            sign_changes += 1;
        }
    }
    sign_changes
}

fn walsh_matrix(size: u32) -> Vec<Vec<i32>> {
    let size = size as usize;
    let mut walsh = vec![vec![0; size]; size];
    walsh[0][0] = 1;

    let mut k = 1;
    while k < size {
        for i in 0..k {
            for j in 0..k {
                walsh[i + k][j] = walsh[i][j];
                walsh[i][j + k] = walsh[i][j];
                walsh[i + k][j + k] = -walsh[i][j];
            }
        }
        k += k;
    }
    walsh
}

fn main() {
    let types = ["Natural", "Sequency"];
    let orders = [2, 4, 5];

    for matrix_type in &types {
        for &order in &orders {
            let size = 1u32 << order;
            println!("Walsh matrix of order {}, {} order:", order, matrix_type);

            let mut walsh = walsh_matrix(size);

            if *matrix_type == "Sequency" {
                walsh.sort_by(|row1, row2| {
                    sign_change_count(row1).cmp(&sign_change_count(row2))
                });
            }

            display(&walsh);
        }
    }
}

fn main() {
    let mut previous_row: Vec<u32> = Vec::new();
    for n in 0..15 {
        let mut current_row: Vec<u32> = Vec::new();
        for k in 0..=n {
            if k == 0 {
                current_row.push(1);
            } else if k < n {
                current_row.push(previous_row[k] + previous_row[k - 1]);
            } else {
                current_row.push(2 * previous_row[previous_row.len() - 1]);
            }
        }
        for entry in &current_row {
            print!("{:<6}", entry);
        }
        println!();
        previous_row = current_row;
    }
}


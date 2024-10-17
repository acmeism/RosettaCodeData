fn main() {
    floyds_triangle(5);
    floyds_triangle(14);
}

fn floyds_triangle(n: u32) {
    let mut triangle: Vec<Vec<String>> = Vec::new();
    let mut current = 0;
    for i in 1..=n {
        let mut v = Vec::new();
        for _ in 0..i {
            current += 1;
            v.push(current);
        }
        let row = v.iter().map(|x| x.to_string()).collect::<Vec<_>>();
        triangle.push(row);
    }

    for row in &triangle {
        let arranged_row: Vec<_> = row
            .iter()
            .enumerate()
            .map(|(i, number)| {
                let space_len = triangle.last().unwrap()[i].len() - number.len() + 1;
                let spaces = " ".repeat(space_len);
                let mut padded_number = spaces;
                padded_number.push_str(&number);
                padded_number
            })
            .collect();
        println!("{}", arranged_row.join(""))
    }
}

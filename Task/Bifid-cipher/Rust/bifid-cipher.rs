use std::collections::HashMap;

type Point = (i32, i32);


struct Bifid {
    grid: Vec<Vec<char>>,
    coordinates: HashMap<char, Point>,
    n: i32,
}

impl Bifid {
    pub fn new(n: i32, text: &str) -> Result<Self, String> {
        if (text.len() as i32) != n * n {
            return Err("Incorrect length of text".to_string());
        }

        let mut grid = vec![vec!['\0'; n as usize]; n as usize];
        let mut coordinates: HashMap<char, Point> = HashMap::new();

        let mut row: i32 = 0;
        let mut col: i32 = 0;

        for ch in text.chars() {
            grid[row as usize][col as usize] = ch;
            coordinates.insert(ch, (row, col));

            col += 1;
            if col == n {
                col = 0;
                row += 1;
            }
        }

        if n == 5 {
            if let Some(&i_coords) = coordinates.get(&'I') {
                coordinates.insert('J', i_coords);
            }
        }

        Ok(Bifid {
            grid,
            coordinates,
            n,
        })
    }

    pub fn encrypt(&self, text: &str) -> String {
        let mut row_one: Vec<i32> = Vec::new();
        let mut row_two: Vec<i32> = Vec::new();

        for ch in text.chars() {
            if let Some(coordinate) = self.coordinates.get(&ch) {
                row_one.push(coordinate.0);
                row_two.push(coordinate.1);
            }
        }

        row_one.extend(row_two.iter());
        let mut result = String::new();
        for i in (0..row_one.len() - 1).step_by(2) {
            result.push(self.grid[row_one[i] as usize][row_one[i + 1] as usize]);
        }
        result
    }

    pub fn decrypt(&self, text: &str) -> String {
        let mut row: Vec<i32> = Vec::new();
        for ch in text.chars() {
            if let Some(coordinate) = self.coordinates.get(&ch) {
                row.push(coordinate.0);
                row.push(coordinate.1);
            }
        }

        let middle = row.len() / 2;
        let row_one: Vec<i32> = row[..middle].to_vec();
        let row_two: Vec<i32> = row[middle..].to_vec();

        let mut result = String::new();
        for i in 0..middle {
            result.push(self.grid[row_one[i] as usize][row_two[i] as usize]);
        }
        result
    }

    pub fn display(&self) {
        for row in &self.grid {
            for ch in row {
                print!("{} ", ch);
            }
            println!();
        }
    }
}

fn run_test(bifid: &Bifid, message: &str) {
    println!("Using Polybius square:");
    bifid.display();
    println!("Message:   {}", message);
    let encrypted = bifid.encrypt(message);
    println!("Encrypted: {}", encrypted);
    let decrypted = bifid.decrypt(&encrypted);
    println!("Decrypted: {}", decrypted);
    println!();
}

fn main() -> Result<(), String> {
    let message1 = "ATTACKATDAWN";
    let message2 = "FLEEATONCE";
    let message3 = "THEINVASIONWILLSTARTONTHEFIRSTOFJANUARY";

    let bifid1 = Bifid::new(5, "ABCDEFGHIKLMNOPQRSTUVWXYZ")?;
    let bifid2 = Bifid::new(5, "BGWKZQPNDSIOAXEFCLUMTHYVR")?;

    run_test(&bifid1, message1);
    run_test(&bifid2, message2);
    run_test(&bifid2, message1);
    run_test(&bifid1, message2);

    let bifid3 = Bifid::new(6, "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")?;
    run_test(&bifid3, message3);

    Ok(())
}

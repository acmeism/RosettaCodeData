use rand::Rng;
use std::io::{self, BufRead, Write};

const EASY: i32 = 1;
const HARD: i32 = 4;

struct Game {
    grid: [i32; 16],
}

impl Game {
    fn new() -> Self {
        let mut grid = [0; 16];
        for i in 0..16 {
            grid[i] = (i + 1) as i32;
        }
        Self { grid }
    }

    fn init_grid(&mut self) {
        for i in 0..16 {
            self.grid[i] = (i + 1) as i32;
        }
    }

    fn set_diff(&mut self, level: i32) {
        let mut rng = rand::thread_rng();
        let moves = if level == HARD { 12 } else { 3 };

        println!("Target is {} moves.", moves);

        let mut i = 0;
        while i < moves {
            let mut rc = Vec::with_capacity(4);
            let r = rng.gen_range(0..2);
            let s = rng.gen_range(0..4);

            if r == 0 { // rotate random row
                for j in (s * 4)..((s + 1) * 4) {
                    rc.push(j);
                }
            } else { // rotate random column
                let mut j = s;
                while j < s + 16 {
                    rc.push(j);
                    j += 4;
                }
            }

            let mut rca = [0; 4];
            for j in 0..4 {
                rca[j] = rc[j];
            }

            self.rotate(rca);

            if self.has_won() { // do it again
                i = -1;
            }

            i += 1;
        }
    }

    fn draw_grid(&self) {
        println!();
        println!("     D1   D2   D3   D4");
        println!("   ╔════╦════╦════╦════╗");
        println!("R1 ║ {:2} ║ {:2} ║ {:2} ║ {:2} ║ L1", self.grid[0], self.grid[1], self.grid[2], self.grid[3]);
        println!("   ╠════╬════╬════╬════╣");
        println!("R2 ║ {:2} ║ {:2} ║ {:2} ║ {:2} ║ L2", self.grid[4], self.grid[5], self.grid[6], self.grid[7]);
        println!("   ╠════╬════╬════╬════╣");
        println!("R3 ║ {:2} ║ {:2} ║ {:2} ║ {:2} ║ L3", self.grid[8], self.grid[9], self.grid[10], self.grid[11]);
        println!("   ╠════╬════╬════╬════╣");
        println!("R4 ║ {:2} ║ {:2} ║ {:2} ║ {:2} ║ L4", self.grid[12], self.grid[13], self.grid[14], self.grid[15]);
        println!("   ╚════╩════╩════╩════╝");
        println!("     U1   U2   U3   U4\n");
    }

    fn rotate(&mut self, ix: [usize; 4]) {
        let last = self.grid[ix[3]];
        for i in (1..=3).rev() {
            self.grid[ix[i]] = self.grid[ix[i-1]];
        }
        self.grid[ix[0]] = last;
    }

    fn has_won(&self) -> bool {
        for i in 0..16 {
            if self.grid[i] != (i + 1) as i32 {
                return false;
            }
        }
        true
    }
}

fn main() -> io::Result<()> {
    let mut game = Game::new();
    let mut level = EASY;
    let stdin = io::stdin();
    let mut stdout = io::stdout();
    let mut reader = stdin.lock();

    loop {
        print!("Enter difficulty level easy or hard E/H : ");
        stdout.flush()?;

        let mut diff = String::new();
        reader.read_line(&mut diff)?;
        let diff = diff.trim().to_uppercase();

        if diff != "E" && diff != "H" {
            println!("Invalid response, try again.");
        } else {
            if diff == "H" {
                level = HARD;
            }
            break;
        }
    }

    game.set_diff(level);

    let mut moves = 0;
    println!("When entering moves, you can also enter Q to quit or S to start again.");

    'outer: loop {
        game.draw_grid();

        if game.has_won() {
            println!("Congratulations, you have won the game in {} moves!!", moves);
            return Ok(());
        }

        loop {
            println!("Moves so far = {}\n", moves);
            print!("Enter move : ");
            stdout.flush()?;

            let mut move_str = String::new();
            reader.read_line(&mut move_str)?;
            let move_str = move_str.trim().to_uppercase();

            let mut ix = [0; 4];

            match move_str.as_str() {
                "D1" | "D2" | "D3" | "D4" => {
                    let c = (move_str.chars().nth(1).unwrap() as usize) - 49;
                    ix[0] = 0 + c;
                    ix[1] = 4 + c;
                    ix[2] = 8 + c;
                    ix[3] = 12 + c;
                    game.rotate(ix);
                    moves += 1;
                    continue 'outer;
                },
                "L1" | "L2" | "L3" | "L4" => {
                    let c = (move_str.chars().nth(1).unwrap() as usize) - 49;
                    ix[0] = 3 + 4 * c;
                    ix[1] = 2 + 4 * c;
                    ix[2] = 1 + 4 * c;
                    ix[3] = 0 + 4 * c;
                    game.rotate(ix);
                    moves += 1;
                    continue 'outer;
                },
                "U1" | "U2" | "U3" | "U4" => {
                    let c = (move_str.chars().nth(1).unwrap() as usize) - 49;
                    ix[0] = 12 + c;
                    ix[1] = 8 + c;
                    ix[2] = 4 + c;
                    ix[3] = 0 + c;
                    game.rotate(ix);
                    moves += 1;
                    continue 'outer;
                },
                "R1" | "R2" | "R3" | "R4" => {
                    let c = (move_str.chars().nth(1).unwrap() as usize) - 49;
                    ix[0] = 0 + 4 * c;
                    ix[1] = 1 + 4 * c;
                    ix[2] = 2 + 4 * c;
                    ix[3] = 3 + 4 * c;
                    game.rotate(ix);
                    moves += 1;
                    continue 'outer;
                },
                "Q" => {
                    return Ok(());
                },
                "S" => {
                    game.init_grid();
                    game.set_diff(level);
                    moves = 0;
                    continue 'outer;
                },
                _ => {
                    println!("Invalid move, try again.");
                }
            }
        }
    }
}

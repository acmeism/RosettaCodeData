use std::io::{self, Write};

#[derive(Clone)] // Add Clone derivation to fix the compilation error
struct Node {
    val: i32,
    neighbors: u8,
}

struct NSolver {
    wid: i32,
    hei: i32,
    max: i32,
    arr: Vec<Node>,
    we_have: Vec<bool>,
    dx: Vec<i32>,
    dy: Vec<i32>,
}

impl NSolver {
    fn new() -> Self {
        NSolver {
            wid: 0,
            hei: 0,
            max: 0,
            arr: Vec::new(),
            we_have: Vec::new(),
            dx: vec![-1, 1, 0, 0],
            dy: vec![0, 0, -1, 1],
        }
    }

    fn solve(&mut self, puzz: &mut Vec<String>, max_wid: i32) {
        if puzz.is_empty() {
            return;
        }

        self.wid = max_wid;
        self.hei = puzz.len() as i32 / self.wid;
        self.max = self.wid * self.hei;
        let len = self.max as usize;

        self.arr = vec![Node { val: 0, neighbors: 0 }; len];
        self.we_have = vec![false; len + 1];

        let mut c = 0;
        for s in puzz.iter() {
            if s == "*" {
                self.max -= 1;
                self.arr[c].val = -1;
                c += 1;
                continue;
            }

            self.arr[c].val = s.parse::<i32>().unwrap_or(0);
            if self.arr[c].val > 0 {
                self.we_have[self.arr[c].val as usize] = true;
            }
            c += 1;
        }

        self.solve_it();

        c = 0;
        for s in puzz.iter_mut() {
            if s == "." {
                *s = self.arr[c].val.to_string();
            }
            c += 1;
        }
    }

    fn search(&mut self, x: i32, y: i32, w: i32, dr: i32) -> bool {
        if (w > self.max && dr > 0) || (w < 1 && dr < 0) || (w == self.max && self.we_have[w as usize]) {
            return true;
        }

        let idx = (x + y * self.wid) as usize;
        self.arr[idx].neighbors = self.get_neighbors(x, y);

        if self.we_have[w as usize] {
            for d in 0..4 {
                if (self.arr[idx].neighbors & (1 << d)) != 0 {
                    let a = x + self.dx[d];
                    let b = y + self.dy[d];
                    let neighbor_idx = (a + b * self.wid) as usize;

                    if self.arr[neighbor_idx].val == w {
                        if self.search(a, b, w + dr, dr) {
                            return true;
                        }
                    }
                }
            }
            return false;
        }

        for d in 0..4 {
            if (self.arr[idx].neighbors & (1 << d)) != 0 {
                let a = x + self.dx[d];
                let b = y + self.dy[d];
                let neighbor_idx = (a + b * self.wid) as usize;

                if self.arr[neighbor_idx].val == 0 {
                    self.arr[neighbor_idx].val = w;
                    if self.search(a, b, w + dr, dr) {
                        return true;
                    }
                    self.arr[neighbor_idx].val = 0;
                }
            }
        }

        false
    }

    fn get_neighbors(&self, x: i32, y: i32) -> u8 {
        let mut retval: u8 = 0;

        for xx in 0..4 {
            let a = x + self.dx[xx];
            let b = y + self.dy[xx];

            if a < 0 || b < 0 || a >= self.wid || b >= self.hei {
                continue;
            }

            let idx = (a + b * self.wid) as usize;
            if self.arr[idx].val > -1 {
                retval |= 1 << xx;
            }
        }

        retval
    }

    fn solve_it(&mut self) {
        let (x, y, z) = self.find_start();
        if z == 99999 {
            println!("\nCan't find start point!");
            return;
        }

        self.search(x, y, z + 1, 1);
        if z > 1 {
            self.search(x, y, z - 1, -1);
        }
    }

    fn find_start(&self) -> (i32, i32, i32) {
        let mut z = 99999;
        let mut x = 0;
        let mut y = 0;

        for b in 0..self.hei {
            for a in 0..self.wid {
                let idx = (a + self.wid * b) as usize;
                if self.arr[idx].val > 0 && self.arr[idx].val < z {
                    x = a;
                    y = b;
                    z = self.arr[idx].val;
                }
            }
        }

        (x, y, z)
    }
}

fn main() {
    let wid = 9;
    //let p = ". . . . . . . . . . . 46 45 . 55 74 . . . 38 . . 43 . . 78 . . 35 . . . . . 71 . . . 33 . . . 59 . . . 17 . . . . . 67 . . 18 . . 11 . . 64 . . . 24 21 . 1  2 . . . . . . . . . . .";
    //let p = ". . . . . . . . . . 11 12 15 18 21 62 61 . .  6 . . . . . 60 . . 33 . . . . . 57 . . 32 . . . . . 56 . . 37 .  1 . . . 73 . . 38 . . . . . 72 . . 43 44 47 48 51 76 77 . . . . . . . . . .";
    let p = "17 . . . 11 . . . 59 . 15 . . 6 . . 61 . . . 3 . . .  63 . . . . . . 66 . . . . 23 24 . 68 67 78 . 54 55 . . . . 72 . . . . . . 35 . . . 49 . . . 29 . . 40 . . 47 . 31 . . . 39 . . . 45";

    let mut puzz: Vec<String> = p.split_whitespace().map(|s| s.to_string()).collect();
    let mut solver = NSolver::new();
    solver.solve(&mut puzz, wid);

    let mut c = 0;
    for s in &puzz {
        if s != "*" && s != "." {
            if let Ok(num) = s.parse::<i32>() {
                if num < 10 {
                    print!("0");
                }
            }
            print!("{} ", s);
        } else {
            print!("   ");
        }

        c += 1;
        if c >= wid {
            println!();
            c = 0;
        }
    }
    println!("\n");

    // Equivalent of system("pause") in Rust
    // print!("Press Enter to continue...");
    // io::stdout().flush().unwrap();
    // let mut input = String::new();
    // io::stdin().read_line(&mut input).unwrap();
}

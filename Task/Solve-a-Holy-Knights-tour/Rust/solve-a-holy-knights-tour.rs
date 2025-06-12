use std::collections::HashSet;
use std::iter::FromIterator;
use std::str::FromStr;

#[derive(Clone, Copy)]
struct Node {
    val: isize,
    neighbors: u8,
}

struct NSolver {
    dx: [isize; 8],
    dy: [isize; 8],
    wid: usize,
    hei: usize,
    max: usize,
    arr: Vec<Node>,
}

impl NSolver {
    fn new() -> Self {
        let dx = [-1, -1, 1, 1, -2, -2, 2, 2];
        let dy = [-2, 2, -2, 2, -1, 1, -1, 1];

        Self {
            dx,
            dy,
            wid: 0,
            hei: 0,
            max: 0,
            arr: vec![],
        }
    }

    fn solve(&mut self, puzz: &mut Vec<String>, max_wid: usize) {
        if puzz.is_empty() {
            return;
        }

        self.wid = max_wid;
        self.hei = puzz.len() / self.wid;
        let len = self.wid * self.hei;
        self.max = len;
        self.arr = vec![Node { val: 0, neighbors: 0 }; len];

        let mut c = 0;
        let mut empty_coords = HashSet::new();

        for s in puzz.iter() {
            if s == "*" {
                self.max -= 1;
                self.arr[c].val = -1;
                c += 1;
                continue;
            }

            if s == "." {
                empty_coords.insert(c);
                c += 1;
                continue;
            }

            if let Ok(val) = isize::from_str(s) {
                self.arr[c].val = val;
                c += 1;
            }
        }

        self.solve_it();

        c = 0;
        for s in puzz.iter_mut() {
            if s == "." {
                let val = self.arr[c].val;
                *s = format!("{:02}", val);
            }
            c += 1;
        }
    }

    fn solve_it(&mut self) {
        let (x, y, z) = self.find_start();
        if z == 99999 {
            println!("Can't find start point!");
            return;
        }

        self.search(x, y, z + 1);
    }

    fn find_start(&self) -> (usize, usize, isize) {
        let mut x = 0;
        let mut y = 0;
        let mut z = 99999;

        for b in 0..self.hei {
            for a in 0..self.wid {
                let idx = a + b * self.wid;
                if self.arr[idx].val > 0 && self.arr[idx].val < z {
                    x = a;
                    y = b;
                    z = self.arr[idx].val;
                }
            }
        }

        (x, y, z)
    }

    fn search(&mut self, x: usize, y: usize, w: isize) -> bool {
        if w > self.max as isize {
            return true;
        }

        let idx = x + y * self.wid;
        self.arr[idx].neighbors = self.get_neighbors(x, y);

        for d in 0..8 {
            if (self.arr[idx].neighbors & (1 << d)) != 0 {
                let a = (x as isize + self.dx[d]) as usize;
                let b = (y as isize + self.dy[d]) as usize;
                let n_idx = a + b * self.wid;

                if self.arr[n_idx].val == 0 {
                    self.arr[n_idx].val = w;
                    if self.search(a, b, w + 1) {
                        return true;
                    }
                    self.arr[n_idx].val = 0;
                }
            }
        }

        false
    }

    fn get_neighbors(&self, x: usize, y: usize) -> u8 {
        let mut c = 0u8;

        for i in 0..8 {
            let a = x as isize + self.dx[i];
            let b = y as isize + self.dy[i];

            if a >= 0 && b >= 0 {
                let a = a as usize;
                let b = b as usize;
                if a < self.wid && b < self.hei {
                    if self.arr[a + b * self.wid].val > -1 {
                        c |= 1 << i;
                    }
                }
            }
        }

        c
    }
}

fn main() {
    // Example input (comment/uncomment for different puzzles)
    let p = "* * * * * 1 * . * * * * * * * * * * . * . * * * * * * * * * . . . . . * * * * * * * * * . . . * * * * * * * . * * . * . * * . * * . . . . . * * * . . . . . * * . . * * * * * . . * * . . . . . * * * . . . . . * * . * * . * . * * . * * * * * * * . . . * * * * * * * * * . . . . . * * * * * * * * * . * . * * * * * * * * * * . * . * * * * * ";
    let wid = 13;

    let puzz: Vec<String> = p.split_whitespace().map(|s| s.to_string()).collect();

    let mut puzz_vec = puzz.clone();

    let mut solver = NSolver::new();
    solver.solve(&mut puzz_vec, wid);

    let mut c = 0;
    for item in puzz_vec.iter() {
        if item == "*" || item == "." {
            print!("   ");
        } else {
            print!("{:2} ", item);
        }

        c += 1;
        if c >= wid {
            println!();
            c = 0;
        }
    }

    println!("\nPress any key to exit...");
    let _ = std::io::stdin().read_line(&mut String::new());
}

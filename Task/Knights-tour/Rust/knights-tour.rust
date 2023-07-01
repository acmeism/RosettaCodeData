use std::fmt;

const SIZE: usize = 8;
const MOVES: [(i32, i32); 8] = [
    (2, 1),
    (1, 2),
    (-1, 2),
    (-2, 1),
    (-2, -1),
    (-1, -2),
    (1, -2),
    (2, -1),
];

#[derive(Copy, Clone, Eq, PartialEq, PartialOrd, Ord)]
struct Point {
    x: i32,
    y: i32,
}

impl Point {
    fn mov(&self, &(dx, dy): &(i32, i32)) -> Self {
        Self {
            x: self.x + dx,
            y: self.y + dy,
        }
    }
}

struct Board {
    field: [[i32; SIZE]; SIZE],
}

impl Board {
    fn new() -> Self {
        Self {
            field: [[0; SIZE]; SIZE],
        }
    }

    fn available(&self, p: Point) -> bool {
        0 <= p.x
            && p.x < SIZE as i32
            && 0 <= p.y
            && p.y < SIZE as i32
            && self.field[p.x as usize][p.y as usize] == 0
    }

    // calculate the number of possible moves
    fn count_degree(&self, p: Point) -> i32 {
        let mut count = 0;
        for dir in MOVES.iter() {
            let next = p.mov(dir);
            if self.available(next) {
                count += 1;
            }
        }
        count
    }
}

impl fmt::Display for Board {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        for row in self.field.iter() {
            for x in row.iter() {
                write!(f, "{:3} ", x)?;
            }
            write!(f, "\n")?;
        }
        Ok(())
    }
}

fn knights_tour(x: i32, y: i32) -> Option<Board> {
    let mut board = Board::new();
    let mut p = Point { x: x, y: y };
    let mut step = 1;
    board.field[p.x as usize][p.y as usize] = step;
    step += 1;

    while step <= (SIZE * SIZE) as i32 {
        // choose next square by Warnsdorf's rule
        let mut candidates = vec![];
        for dir in MOVES.iter() {
            let adj = p.mov(dir);
            if board.available(adj) {
                let degree = board.count_degree(adj);
                candidates.push((degree, adj));
            }
        }
        match candidates.iter().min() {
            // move to next square
            Some(&(_, adj)) => p = adj,
            // can't move
            None => return None,
        };
        board.field[p.x as usize][p.y as usize] = step;
        step += 1;
    }
    Some(board)
}

fn main() {
    let (x, y) = (3, 1);
    println!("Board size: {}", SIZE);
    println!("Starting position: ({}, {})", x, y);
    match knights_tour(x, y) {
        Some(b) => print!("{}", b),
        None => println!("Fail!"),
    }
}

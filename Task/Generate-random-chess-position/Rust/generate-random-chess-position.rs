use std::fmt::Write;

use rand::{Rng, distributions::{Distribution, Standard}};

const EMPTY: u8 = b'.';

#[derive(Clone, Debug)]
struct Board {
    grid: [[u8; 8]; 8],
}

impl Distribution<Board> for Standard {
    fn sample<R: Rng + ?Sized>(&self, rng: &mut R) -> Board {
        let mut board = Board::empty();
        board.place_kings(rng);
        board.place_pieces(rng, b"PPPPPPPP", true);
        board.place_pieces(rng, b"pppppppp", true);
        board.place_pieces(rng, b"RNBQBNR", false);
        board.place_pieces(rng, b"rnbqbnr", false);
        board
    }
}

impl Board {
    fn empty() -> Self {
        Board { grid: [[EMPTY; 8]; 8] }
    }

    fn fen(&self) -> String {
        let mut fen = String::new();
        let mut count_empty = 0;
        for row in &self.grid {
            for &ch in row {
                print!("{} ", ch as char);
                if ch == EMPTY {
                    count_empty += 1;
                } else {
                    if count_empty > 0 {
                        write!(fen, "{}", count_empty).unwrap();
                        count_empty = 0;
                    }
                    fen.push(ch as char);
                }
            }
            if count_empty > 0 {
                write!(fen, "{}", count_empty).unwrap();
                count_empty = 0;
            }
            fen.push('/');
            println!();
        }
        fen.push_str(" w - - 0 1");
        fen
    }

    fn place_kings<R: Rng + ?Sized>(&mut self, rng: &mut R) {
        loop {
            let r1: i8 = rng.gen_range(0, 8);
            let c1: i8 = rng.gen_range(0, 8);
            let r2: i8 = rng.gen_range(0, 8);
            let c2: i8 = rng.gen_range(0, 8);
            if r1 != r2 && (r1 - r2).abs() > 1 && (c1 - c2).abs() > 1 {
                self.grid[r1 as usize][c1 as usize] = b'K';
                self.grid[r2 as usize][c2 as usize] = b'k';
                return;
            }
        }
    }

    fn place_pieces<R: Rng + ?Sized>(&mut self, rng: &mut R, pieces: &[u8], is_pawn: bool) {
        let num_to_place = rng.gen_range(0, pieces.len());
        for &piece in pieces.iter().take(num_to_place) {
            let mut r = rng.gen_range(0, 8);
            let mut c = rng.gen_range(0, 8);
            while self.grid[r][c] != EMPTY || (is_pawn && (r == 7 || r == 0)) {
                r = rng.gen_range(0, 8);
                c = rng.gen_range(0, 8);
            }
            self.grid[r][c] = piece;
        }
    }
}

fn main() {
    let b: Board = rand::random();
    println!("{}", b.fen());
}

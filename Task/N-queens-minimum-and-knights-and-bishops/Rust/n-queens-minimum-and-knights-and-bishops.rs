use std::collections::HashMap;
use std::time::Instant;

struct ChessBoard {
    board: Vec<Vec<bool>>,
    diag1: Vec<Vec<usize>>,
    diag2: Vec<Vec<usize>>,
    diag1_lookup: Vec<bool>,
    diag2_lookup: Vec<bool>,
    n: usize,
    min_count: usize,
    layout: String,
}

impl ChessBoard {
    fn new(n: usize, piece: &str) -> Self {
        let board = vec![vec![false; n]; n];

        let (diag1, diag2, diag1_lookup, diag2_lookup) = if piece != "K" {
            let mut diag1 = vec![vec![0; n]; n];
            let mut diag2 = vec![vec![0; n]; n];

            for i in 0..n {
                for j in 0..n {
                    diag1[i][j] = i + j;
                    diag2[i][j] = i + n - 1 - j;
                }
            }

            let diag1_lookup = vec![false; 2 * n - 1];
            let diag2_lookup = vec![false; 2 * n - 1];

            (diag1, diag2, diag1_lookup, diag2_lookup)
        } else {
            (vec![], vec![], vec![], vec![])
        };

        ChessBoard {
            board,
            diag1,
            diag2,
            diag1_lookup,
            diag2_lookup,
            n,
            min_count: usize::MAX,
            layout: String::new(),
        }
    }

    fn is_attacked(&self, piece: &str, row: usize, col: usize) -> bool {
        match piece {
            "Q" => {
                // Check row and column
                for i in 0..self.n {
                    if self.board[i][col] || self.board[row][i] {
                        return true;
                    }
                }
                // Check diagonals
                if self.diag1_lookup[self.diag1[row][col]] || self.diag2_lookup[self.diag2[row][col]] {
                    return true;
                }
            }
            "B" => {
                // Check diagonals only
                if self.diag1_lookup[self.diag1[row][col]] || self.diag2_lookup[self.diag2[row][col]] {
                    return true;
                }
            }
            "K" => {
                // Check if current position is occupied
                if self.board[row][col] {
                    return true;
                }

                // Check all knight moves
                let knight_moves = [
                    (2i32, -1i32), (-2, -1), (2, 1), (-2, 1),
                    (1, 2), (-1, 2), (1, -2), (-1, -2)
                ];

                for (dr, dc) in knight_moves.iter() {
                    let new_row = row as i32 + dr;
                    let new_col = col as i32 + dc;

                    if new_row >= 0 && new_row < self.n as i32 &&
                       new_col >= 0 && new_col < self.n as i32 {
                        if self.board[new_row as usize][new_col as usize] {
                            return true;
                        }
                    }
                }
            }
            _ => {}
        }
        false
    }

    fn attacks(&self, piece: &str, row: usize, col: usize, trow: usize, tcol: usize) -> bool {
        match piece {
            "Q" => {
                row == trow || col == tcol ||
                (row as i32 - trow as i32).abs() == (col as i32 - tcol as i32).abs()
            }
            "B" => {
                (row as i32 - trow as i32).abs() == (col as i32 - tcol as i32).abs()
            }
            "K" => {
                let rd = (trow as i32 - row as i32).abs();
                let cd = (tcol as i32 - col as i32).abs();
                (rd == 1 && cd == 2) || (rd == 2 && cd == 1)
            }
            _ => false
        }
    }

    fn store_layout(&mut self, piece: &str) {
        let mut layout = String::new();
        for row in &self.board {
            for &cell in row {
                if cell {
                    layout.push_str(&format!("{} ", piece));
                } else {
                    layout.push_str(". ");
                }
            }
            layout.push('\n');
        }
        self.layout = layout;
    }

    fn place_piece(&mut self, piece: &str, count_so_far: usize, max_count: usize) {
        if count_so_far >= self.min_count {
            return;
        }

        // Find first unattacked square
        let mut all_attacked = true;
        let mut ti = 0;
        let mut tj = 0;

        'outer: for i in 0..self.n {
            for j in 0..self.n {
                if !self.is_attacked(piece, i, j) {
                    all_attacked = false;
                    ti = i;
                    tj = j;
                    break 'outer;
                }
            }
        }

        if all_attacked {
            self.min_count = count_so_far;
            self.store_layout(piece);
            return;
        }

        if count_so_far <= max_count {
            let (si, sj) = if piece == "K" {
                let si = ti.saturating_sub(2);
                let sj = tj.saturating_sub(2);
                (si, sj)
            } else {
                (ti, tj)
            };

            for i in si..self.n {
                for j in sj..self.n {
                    if !self.is_attacked(piece, i, j) {
                        if (i == ti && j == tj) || self.attacks(piece, i, j, ti, tj) {
                            // Place piece
                            self.board[i][j] = true;
                            if piece != "K" {
                                self.diag1_lookup[self.diag1[i][j]] = true;
                                self.diag2_lookup[self.diag2[i][j]] = true;
                            }

                            // Recurse
                            self.place_piece(piece, count_so_far + 1, max_count);

                            // Remove piece (backtrack)
                            self.board[i][j] = false;
                            if piece != "K" {
                                self.diag1_lookup[self.diag1[i][j]] = false;
                                self.diag2_lookup[self.diag2[i][j]] = false;
                            }
                        }
                    }
                }
            }
        }
    }
}

fn main() {
    let start = Instant::now();

    let pieces = vec!["Q", "B", "K"];
    let mut limits = HashMap::new();
    limits.insert("Q", 10);
    limits.insert("B", 10);
    limits.insert("K", 10);

    let mut names = HashMap::new();
    names.insert("Q", "Queens");
    names.insert("B", "Bishops");
    names.insert("K", "Knights");

    for piece in pieces {
        println!("{}", names[piece]);
        println!("=======\n");

        let mut n = 1;
        loop {
            let mut chess_board = ChessBoard::new(n, piece);

            for max_count in 1..=(n * n) {
                chess_board.place_piece(piece, 0, max_count);
                if chess_board.min_count <= n * n {
                    break;
                }
            }

            println!("{:2} x {:2} : {}", n, n, chess_board.min_count);

            if n == limits[piece] {
                println!("\n{} on a {} x {} board:\n", names[piece], n, n);
                println!("{}", chess_board.layout);
                break;
            }

            n += 1;
        }
    }

    let elapsed = start.elapsed();
    println!("Took {}ms", elapsed.as_millis());
}

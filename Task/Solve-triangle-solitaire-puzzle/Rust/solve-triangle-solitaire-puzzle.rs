use std::collections::HashMap;
use std::fmt;

struct Move {
    peg: u32,
    over: u32,
    land: u32,
}

const MAX_PEGS: usize = 16;

struct Board {
    pegs: [bool; MAX_PEGS],
}

impl Board {
    fn new() -> Self {
        let mut pegs = [false; MAX_PEGS];
        for i in 1..MAX_PEGS {
            pegs[i] = true;
        }
        Board { pegs }
    }

    fn count(&self) -> usize {
        self.pegs.iter().filter(|&&peg| peg).count()
    }

    fn is_solved(&self) -> bool {
        self.count() == 1
    }
}

impl fmt::Display for Board {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let pegs: Vec<char> = (1..MAX_PEGS)
            .map(|i| if self.pegs[i] {
                format!("{:X}", i).chars().next().unwrap()
            } else {
                '-'
            })
            .collect();

        writeln!(f, "       {}", pegs[0])?;
        writeln!(f, "      {} {}", pegs[1], pegs[2])?;
        writeln!(f, "     {} {} {}", pegs[3], pegs[4], pegs[5])?;
        writeln!(f, "    {} {} {} {}", pegs[6], pegs[7], pegs[8], pegs[9])?;
        writeln!(f, "   {} {} {} {} {}", pegs[10], pegs[11], pegs[12], pegs[13], pegs[14])?;
        Ok(())
    }
}

fn create_valid_moves() -> HashMap<u32, Vec<Move>> {
    let mut valid_moves = HashMap::new();

    valid_moves.insert(1, vec![
        Move { peg: 1, over: 2, land: 4 },
        Move { peg: 1, over: 3, land: 6 },
    ]);
    valid_moves.insert(2, vec![
        Move { peg: 2, over: 4, land: 7 },
        Move { peg: 2, over: 5, land: 9 },
    ]);
    valid_moves.insert(3, vec![
        Move { peg: 3, over: 5, land: 8 },
        Move { peg: 3, over: 6, land: 10 },
    ]);
    valid_moves.insert(4, vec![
        Move { peg: 4, over: 2, land: 1 },
        Move { peg: 4, over: 5, land: 6 },
        Move { peg: 4, over: 8, land: 13 },
        Move { peg: 4, over: 7, land: 11 },
    ]);
    valid_moves.insert(5, vec![
        Move { peg: 5, over: 8, land: 12 },
        Move { peg: 5, over: 9, land: 14 },
    ]);
    valid_moves.insert(6, vec![
        Move { peg: 6, over: 3, land: 1 },
        Move { peg: 6, over: 5, land: 4 },
        Move { peg: 6, over: 9, land: 13 },
        Move { peg: 6, over: 10, land: 15 },
    ]);
    valid_moves.insert(7, vec![
        Move { peg: 7, over: 4, land: 2 },
        Move { peg: 7, over: 8, land: 9 },
    ]);
    valid_moves.insert(8, vec![
        Move { peg: 8, over: 5, land: 3 },
        Move { peg: 8, over: 9, land: 10 },
    ]);
    valid_moves.insert(9, vec![
        Move { peg: 9, over: 5, land: 2 },
        Move { peg: 9, over: 8, land: 7 },
    ]);
    valid_moves.insert(10, vec![
        Move { peg: 10, over: 6, land: 3 },
        Move { peg: 10, over: 9, land: 8 },
    ]);
    valid_moves.insert(11, vec![
        Move { peg: 11, over: 7, land: 4 },
        Move { peg: 11, over: 12, land: 13 },
    ]);
    valid_moves.insert(12, vec![
        Move { peg: 12, over: 8, land: 5 },
        Move { peg: 12, over: 13, land: 14 },
    ]);
    valid_moves.insert(13, vec![
        Move { peg: 13, over: 12, land: 11 },
        Move { peg: 13, over: 8, land: 5 },
        Move { peg: 13, over: 9, land: 6 },
        Move { peg: 13, over: 14, land: 15 },
    ]);
    valid_moves.insert(14, vec![
        Move { peg: 14, over: 13, land: 12 },
        Move { peg: 14, over: 9, land: 5 },
    ]);
    valid_moves.insert(15, vec![
        Move { peg: 15, over: 14, land: 13 },
        Move { peg: 15, over: 10, land: 6 },
    ]);

    valid_moves
}

fn solve(
    board: &mut Board,
    valid_moves: &HashMap<u32, Vec<Move>>,
    solution: &mut Vec<Move>
) -> bool {
    if board.is_solved() {
        return true;
    }

    for peg in 1..MAX_PEGS {
        if board.pegs[peg] {
            if let Some(moves) = valid_moves.get(&(peg as u32)) {
                for move_option in moves {
                    if board.pegs[move_option.over as usize] && !board.pegs[move_option.land as usize] {
                        // Save board state
                        let saved_board = board.pegs;

                        // Make the move
                        board.pegs[peg] = false;
                        board.pegs[move_option.over as usize] = false;
                        board.pegs[move_option.land as usize] = true;

                        solution.push(Move {
                            peg: move_option.peg,
                            over: move_option.over,
                            land: move_option.land,
                        });

                        // Recursively solve
                        if solve(board, valid_moves, solution) {
                            return true;
                        }

                        // Backtrack
                        board.pegs = saved_board;
                        solution.pop();
                    }
                }
            }
        }
    }

    false
}

fn main() {
    let empty_peg: u32 = 1;
    let valid_moves = create_valid_moves();
    let mut solution = Vec::new();

    // Solve the puzzle
    let mut board = Board::new();
    board.pegs[empty_peg as usize] = false;

    solve(&mut board, &valid_moves, &mut solution);

    // Reset the board and display the solution
    let mut board = Board::new();
    board.pegs[empty_peg as usize] = false;

    println!("{}", board);
    println!("Starting with peg {:X} removed\n", empty_peg);

    for move_step in &solution {
        board.pegs[move_step.peg as usize] = false;
        board.pegs[move_step.over as usize] = false;
        board.pegs[move_step.land as usize] = true;

        println!("{}", board);
        println!(
            "Peg {:X} jumped over {:X} to land on {:X}\n",
            move_step.peg, move_step.over, move_step.land
        );
    }
}

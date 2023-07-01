type Sudoku = [u8; 81];

fn is_valid(val: u8, x: usize, y: usize, sudoku_ar: &mut Sudoku) -> bool {
    (0..9).all(|i| sudoku_ar[y * 9 + i] != val && sudoku_ar[i * 9 + x] != val) && {
        let (start_x, start_y) = ((x / 3) * 3, (y / 3) * 3);
        (start_y..start_y + 3).all(|i| (start_x..start_x + 3).all(|j| sudoku_ar[i * 9 + j] != val))
    }
}

fn place_number(pos: usize, sudoku_ar: &mut Sudoku) -> bool {
    (pos..81).find(|&p| sudoku_ar[p] == 0).map_or(true, |pos| {
        let (x, y) = (pos % 9, pos / 9);
        for n in 1..10 {
            if is_valid(n, x, y, sudoku_ar) {
                sudoku_ar[pos] = n;
                if place_number(pos + 1, sudoku_ar) {
                    return true;
                }
                sudoku_ar[pos] = 0;
            }
        }
        false
    })
}

fn pretty_print(sudoku_ar: Sudoku) {
    let line_sep = "------+-------+------";
    println!("{}", line_sep);
    for (i, e) in sudoku_ar.iter().enumerate() {
        print!("{} ", e);
        if (i + 1) % 3 == 0 && (i + 1) % 9 != 0 {
            print!("| ");
        }
        if (i + 1) % 9 == 0 {
            println!(" ");
        }
        if (i + 1) % 27 == 0 {
            println!("{}", line_sep);
        }
    }
}

fn solve(sudoku_ar: &mut Sudoku) -> bool {
    place_number(0, sudoku_ar)
}

fn main() {
    let mut sudoku_ar: Sudoku = [
        8, 5, 0, 0, 0, 2, 4, 0, 0,
        7, 2, 0, 0, 0, 0, 0, 0, 9,
        0, 0, 4, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 1, 0, 7, 0, 0, 2,
        3, 0, 5, 0, 0, 0, 9, 0, 0,
        0, 4, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 8, 0, 0, 7, 0,
        0, 1, 7, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 3, 6, 0, 4, 0
    ];
    if solve(&mut sudoku_ar) {
        pretty_print(sudoku_ar);
    } else {
        println!("Unsolvable");
    }
}

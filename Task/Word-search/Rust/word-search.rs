use once_cell::sync::Lazy;
use rand::rngs::ThreadRng;
use rand::seq::SliceRandom;
use regex::Regex;
use std::fs;

const DIRS: [[i32; 2]; 8] = [
    [1, 0],
    [0, 1],
    [1, 1],
    [1, -1],
    [-1, 0],
    [0, -1],
    [-1, -1],
    [-1, 1],
];
const NROWS: usize = 10;
const NCOLS: usize = NROWS;
const GRIDSIZE: usize = NROWS * NCOLS;
const MINWORDS: usize = 25;

struct Grid {
    num_attempts: usize,
    cells: Vec<Vec<u8>>,
    solutions: Vec<String>,
}

fn new_grid() -> Grid {
    return Grid {
        num_attempts: 0,
        cells: vec![vec![0_u8; NCOLS]; NROWS],
        solutions: vec![String::new(); 0],
    };
}

fn read_words(file_name: &str) -> Vec<String> {
    let re = Regex::new(r"^[a-z]{3,10}$").unwrap();
    let wordsfile = fs::read_to_string(file_name).unwrap().to_lowercase();
    return wordsfile
        .split_whitespace()
        .filter(|w| re.is_match(w))
        .map(|x| x.to_owned())
        .collect::<Vec<String>>();
}

fn create_word_search(mut words: Vec<String>) -> Grid {
    let mut rng = rand::thread_rng();
    let mut gr = new_grid();
    'outer: for i in 1..100 {
        // up to 100 tries
        gr = new_grid();
        let message_len = place_message(&mut gr, "Rosetta Code", &mut rng);
        let target = GRIDSIZE - message_len;
        let mut cells_filled = 0_usize;
        words.shuffle(&mut rng);
        for word in &words {
            cells_filled += try_place_word(&mut gr, &word, &mut rng);
            if cells_filled == target {
                if gr.solutions.len() >= MINWORDS {
                    gr.num_attempts = i;
                    break 'outer; // outer for
                } else {
                    break; // inner for
                }
            }
        }
    }
    return gr;
}

fn place_message(gr: &mut Grid, msg: &str, rng: &mut ThreadRng) -> usize {
    static RE: Lazy<Regex> = Lazy::new(|| Regex::new(r"[^A-Z]").unwrap());
    let mut smsg = msg.to_uppercase();
    smsg = RE.replace(&&smsg, "").to_string();
    let message_len = smsg.len();
    if message_len > 0 && message_len < GRIDSIZE {
        let gap_size = GRIDSIZE / message_len;
        for i in 0..message_len {
            let rpos = i * gap_size + (0..gap_size).collect::<Vec<usize>>().choose(rng).unwrap();
            gr.cells[rpos / NCOLS][rpos % NCOLS] = smsg.as_bytes()[i];
        }
        return message_len;
    }
    return 0;
}

fn try_place_word(gr: &mut Grid, word: &str, rng: &mut ThreadRng) -> usize {
    let binding = (0..DIRS.len()).collect::<Vec<usize>>();
    let rand_dir = binding.choose(rng).unwrap();
    let bindingp = (0..GRIDSIZE).collect::<Vec<usize>>();
    let rand_pos = bindingp.choose(rng).unwrap();
    for dir in 0..DIRS.len() {
        let rdir = (dir + rand_dir) % DIRS.len();
        for pos in 0..GRIDSIZE {
            let rpos = (pos + rand_pos) % GRIDSIZE;
            let letters_placed = try_location(gr, word, rdir, rpos);
            if letters_placed > 0 {
                return letters_placed;
            }
        }
    }
    return 0;
}

fn try_location(gr: &mut Grid, word: &str, dir: usize, pos: usize) -> usize {
    let r = pos / NCOLS;
    let c = pos % NCOLS;
    let le = word.len();

    // check bounds
    if (DIRS[dir][0] == 1 && (le + c) > NCOLS)
        || (DIRS[dir][0] == -1 && (le - 1) > c)
        || (DIRS[dir][1] == 1 && (le + r) > NROWS)
        || (DIRS[dir][1] == -1 && (le - 1) > r)
    {
        return 0;
    }
    let mut overlaps = 0;

    // check cells
    let mut rr: i32 = r.try_into().unwrap();
    let mut cc: i32 = c.try_into().unwrap();
    for i in 0..le {
        if gr.cells[rr as usize][cc as usize] != 0
            && gr.cells[rr as usize][cc as usize] != word.as_bytes()[i]
        {
            return 0;
        }
        cc += DIRS[dir][0];
        rr += DIRS[dir][1];
    }

    // place
    rr = r.try_into().unwrap();
    cc = c.try_into().unwrap();
    for i in 0..le {
        if gr.cells[rr as usize][cc as usize] == word.as_bytes()[i] {
            overlaps += 1;
        } else {
            gr.cells[rr as usize][cc as usize] = word.as_bytes()[i];
        }
        if i < le - 1 {
            cc += DIRS[dir][0];
            rr += DIRS[dir][1];
        }
    }

    let letters_placed = le - overlaps;
    if letters_placed > 0 {
        let sol = format!("{:>10} ({},{})({},{})", word, c, r, cc, rr);
        gr.solutions.push(sol);
    }
    return letters_placed;
}

fn print_result(gr: Grid) {
    if gr.num_attempts == 0 {
        println!("\nWord search puzzle: No grid to display\n");
        return;
    }
    let size = gr.solutions.len();
    println!(
        "Word search puzzle solution:\n Attempts: {}",
        gr.num_attempts
    );
    println!(" Number of words: {}", size);
    println!("\n     0  1  2  3  4  5  6  7  8  9");
    for r in 0..NROWS {
        print!("\n{}   ", r);
        for c in 0..NCOLS {
            print!(" {} ", gr.cells[r][c] as char);
        }
    }
    println!("\n");
    for i in (0..size - 1).step_by(2) {
        println!("{}   {}", gr.solutions[i], gr.solutions[i + 1]);
    }
    if size % 2 == 1 {
        println!("{}", gr.solutions[size - 1]);
    }
}

fn main() {
    let dict_path = "unixdict.txt";
    print_result(create_word_search(read_words(dict_path)));
}

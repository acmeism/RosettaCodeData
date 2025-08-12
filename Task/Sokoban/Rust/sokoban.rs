use std::collections::{HashSet, VecDeque};
use regex::Regex;

#[derive(Debug, Clone)]
struct Board {
    s_data: Vec<Vec<char>>,
    d_data: Vec<Vec<char>>,
    px: usize,
    py: usize,
}

impl Board {
    fn new(board_str: &str) -> Self {
        let pattern = Regex::new(r"([^\n]+)\n?").unwrap();
        let mut data = Vec::new();
        let mut w = 0;

        for cap in pattern.captures_iter(board_str) {
            let line = cap[1].to_string();
            w = w.max(line.len());
            data.push(line);
        }

        let mut s_data = Vec::new();
        let mut d_data = Vec::new();
        let mut px = 0;
        let mut py = 0;

        for (v, line) in data.iter().enumerate() {
            let mut s_temp = Vec::new();
            let mut d_temp = Vec::new();

            for u in 0..w {
                let (s, d) = if u >= line.len() {
                    (' ', ' ')
                } else {
                    let c = line.chars().nth(u).unwrap();
                    let mut s = ' ';
                    let mut d = ' ';

                    match c {
                        '#' => s = '#',
                        '.' | '*' | '+' => s = '.',
                        _ => {}
                    }

                    match c {
                        '@' | '+' => {
                            d = '@';
                            px = u;
                            py = v;
                        }
                        '$' | '*' => d = '*',
                        _ => {}
                    }

                    (s, d)
                };

                s_temp.push(s);
                d_temp.push(d);
            }

            s_data.push(s_temp);
            d_data.push(d_temp);
        }

        Board {
            s_data,
            d_data,
            px,
            py,
        }
    }

    fn move_player(&self, x: usize, y: usize, dx: i32, dy: i32, data: &mut Vec<Vec<char>>) -> bool {
        let new_x = (x as i32 + dx) as usize;
        let new_y = (y as i32 + dy) as usize;

        if self.s_data[new_y][new_x] == '#' || data[new_y][new_x] != ' ' {
            return false;
        }

        data[y][x] = ' ';
        data[new_y][new_x] = '@';

        true
    }

    fn push_box(&self, x: usize, y: usize, dx: i32, dy: i32, data: &mut Vec<Vec<char>>) -> bool {
        let new_x = (x as i32 + dx) as usize;
        let new_y = (y as i32 + dy) as usize;
        let box_x = (x as i32 + 2 * dx) as usize;
        let box_y = (y as i32 + 2 * dy) as usize;

        if self.s_data[box_y][box_x] == '#' || data[box_y][box_x] != ' ' {
            return false;
        }

        data[y][x] = ' ';
        data[new_y][new_x] = '@';
        data[box_y][box_x] = '*';

        true
    }

    fn is_solved(&self, data: &Vec<Vec<char>>) -> bool {
        for (v, row) in data.iter().enumerate() {
            for (u, &cell) in row.iter().enumerate() {
                if (self.s_data[v][u] == '.') != (cell == '*') {
                    return false;
                }
            }
        }
        true
    }

    fn solve(&self) -> String {
        let mut visited = HashSet::new();
        let mut open = VecDeque::new();

        open.push_back((self.d_data.clone(), String::new(), self.px, self.py));
        visited.insert(self.d_data.clone());

        let dirs = [
            (0, -1, 'u', 'U'),
            (1, 0, 'r', 'R'),
            (0, 1, 'd', 'D'),
            (-1, 0, 'l', 'L'),
        ];

        while let Some((cur, c_sol, x, y)) = open.pop_front() {
            for &(dx, dy, move_char, push_char) in &dirs {
                let mut temp = cur.clone();
                let new_x = (x as i32 + dx) as usize;
                let new_y = (y as i32 + dy) as usize;

                if temp[new_y][new_x] == '*' {
                    if self.push_box(x, y, dx, dy, &mut temp) && !visited.contains(&temp) {
                        if self.is_solved(&temp) {
                            return c_sol + &push_char.to_string();
                        }
                        open.push_back((temp.clone(), c_sol.clone() + &push_char.to_string(), new_x, new_y));
                        visited.insert(temp);
                    }
                } else if self.move_player(x, y, dx, dy, &mut temp) && !visited.contains(&temp) {
                    if self.is_solved(&temp) {
                        return c_sol + &move_char.to_string();
                    }
                    open.push_back((temp.clone(), c_sol.clone() + &move_char.to_string(), new_x, new_y));
                    visited.insert(temp);
                }
            }
        }

        "No solution".to_string()
    }
}

fn main() {
    let level = "#######\n\
                 #     #\n\
                 #     #\n\
                 #. #  #\n\
                 #. $$ #\n\
                 #.$$  #\n\
                 #.#  @#\n\
                 #######";

    let board = Board::new(level);
    println!("{}\n", level);
    println!("{}", board.solve());
}

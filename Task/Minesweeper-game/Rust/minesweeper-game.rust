extern crate rand;

use std::io;
use std::io::Write;

fn main() {

    use minesweeper::{MineSweeper, GameStatus};

    let mut width = 6;
    let mut height = 4;
    let mut mine_perctg = 10;
    let mut game = MineSweeper::new(width, height, mine_perctg);

    loop {
        let mut command = String::new();

        println!(
            "\n\
             M I N E S W E E P E R\n\
             \n\
             Commands: \n\
             line col            - reveal line,col \n\
             m line col          - mark   line,col \n\
             q                   - quit\n\
             n                   - new game\n\
             n width height perc - new game size and mine percentage\n"
        );

        game.print();
        print!("> ");
        io::stdout().flush().unwrap();
        while let Ok(_) = io::stdin().read_line(&mut command) {
            let mut command_ok = false;
            {
                let values: Vec<&str> = command.trim().split(' ').collect();
                if values.len() == 1 {
                    if values[0] == "q" {
                        println!("Goodbye");
                        return;
                    } else if values[0] == "n" {
                        println!("New game");
                        game = MineSweeper::new(width, height, mine_perctg);
                        command_ok = true;
                    }
                } else if values.len() == 2 {
                    if let (Ok(x), Ok(y)) = (
                        values[0].parse::<usize>(),
                        values[1].parse::<usize>(),
                    )
                    {
                        game.play(x - 1, y - 1);

                        match game.game_status {
                            GameStatus::Won => println!("You won!"),
                            GameStatus::Lost => println!("You lost!"),
                            _ => (),
                        }
                        command_ok = true;
                    }
                } else if values.len() == 3 {
                    if values[0] == "m" {
                        if let (Ok(x), Ok(y)) = (
                            values[1].parse::<usize>(),
                            values[2].parse::<usize>(),
                        )
                        {
                            game.mark(x - 1, y - 1);
                            command_ok = true;
                        }
                    }
                } else if values.len() == 4 {
                    if values[0] == "n" {
                        if let (Ok(new_width), Ok(new_height), Ok(new_mines_perctg)) =
                            (
                                values[1].parse::<usize>(),
                                values[2].parse::<usize>(),
                                values[3].parse::<usize>(),
                            )
                        {
                            width = new_width;
                            height = new_height;
                            mine_perctg = new_mines_perctg;
                            game = MineSweeper::new(width, height, mine_perctg);
                            command_ok = true;
                        }
                    }
                }
            }

            if command_ok {
                game.print();
            } else {
                println!("Invalid command");
            }

            print!("> ");
            io::stdout().flush().unwrap();
            command.clear();
        }
    }
}

pub mod minesweeper {

    pub struct MineSweeper {
        cell: [[Cell; 100]; 100],
        pub game_status: GameStatus,
        mines: usize,
        width: usize,
        height: usize,
        revealed_count: usize,
    }

    #[derive(Copy, Clone)]
    struct Cell {
        content: CellContent,
        mark: Mark,
        revealed: bool,
    }

    #[derive(Copy, Clone)]
    enum CellContent {
        Empty,
        Mine,
        MineNeighbour { count: u8 },
    }

    #[derive(Copy, Clone)]
    enum Mark {
        None,
        Mine,
    }

    pub enum GameStatus {
        InGame,
        Won,
        Lost,
    }

    extern crate rand;

    use std::cmp::max;
    use std::cmp::min;
    use self::rand::Rng;
    use self::CellContent::*;
    use self::GameStatus::*;

    impl MineSweeper {
        pub fn new(width: usize, height: usize, percentage_of_mines: usize) -> MineSweeper {
            let mut game = MineSweeper {
                cell: [[Cell {
                    content: Empty,
                    mark: Mark::None,
                    revealed: false,
                }; 100]; 100],
                game_status: InGame,
                mines: (width * height * percentage_of_mines) / 100,
                width: width,
                height: height,
                revealed_count: 0,
            };
            game.put_mines();
            game.calc_neighbours();
            game
        }

        pub fn play(&mut self, x: usize, y: usize) {
            match self.game_status {
                InGame => {
                    if !self.cell[x][y].revealed {
                        match self.cell[x][y].content {
                            Mine => {
                                self.cell[x][y].revealed = true;
                                self.revealed_count += 1;
                                self.game_status = Lost;
                            }
                            Empty => {
                                self.flood_fill_reveal(x, y);
                                if self.revealed_count + self.mines == self.width * self.height {
                                    self.game_status = Won;
                                }
                            }
                            MineNeighbour { .. } => {
                                self.cell[x][y].revealed = true;
                                self.revealed_count += 1;
                                if self.revealed_count + self.mines == self.width * self.height {
                                    self.game_status = Won;
                                }
                            }
                        }
                    }
                }
                _ => println!("Game has ended"),
            }
        }

        pub fn mark(&mut self, x: usize, y: usize) {
            self.cell[x][y].mark = match self.cell[x][y].mark {
                Mark::None => Mark::Mine,
                Mark::Mine => Mark::None,
            }
        }

        pub fn print(&self) {
            print!("┌");
            for _ in 0..self.width {
                print!("─");
            }
            println!("┐");
            for y in 0..self.height {
                print!("│");
                for x in 0..self.width {
                    self.cell[x][y].print();
                }
                println!("│");
            }
            print!("└");
            for _ in 0..self.width {
                print!("─");
            }
            println!("┘");
        }

        fn put_mines(&mut self) {
            let mut rng = rand::thread_rng();
            for _ in 0..self.mines {
                while let (x, y, true) = (
                    rng.gen::<usize>() % self.width,
                    rng.gen::<usize>() % self.height,
                    true,
                )
                {
                    match self.cell[x][y].content {
                        Mine => continue,
                        _ => {
                            self.cell[x][y].content = Mine;
                            break;
                        }
                    }
                }
            }
        }

        fn calc_neighbours(&mut self) {
            for x in 0..self.width {
                for y in 0..self.height {
                    if !self.cell[x][y].is_bomb() {
                        let mut adjacent_bombs = 0;

                        for i in max(x as isize - 1, 0) as usize..min(x + 2, self.width) {
                            for j in max(y as isize - 1, 0) as usize..min(y + 2, self.height) {
                                adjacent_bombs += if self.cell[i][j].is_bomb() { 1 } else { 0 };
                            }
                        }

                        if adjacent_bombs == 0 {
                            self.cell[x][y].content = Empty;
                        } else {
                            self.cell[x][y].content = MineNeighbour { count: adjacent_bombs };
                        }
                    }
                }
            }
        }

        fn flood_fill_reveal(&mut self, x: usize, y: usize) {
            let mut stack = Vec::<(usize, usize)>::new();
            stack.push((x, y));

            while let Some((i, j)) = stack.pop() {
                if self.cell[i][j].revealed {
                    continue;
                }
                self.cell[i][j].revealed = true;
                self.revealed_count += 1;
                if let Empty = self.cell[i][j].content {
                    for m in max(i as isize - 1, 0) as usize..min(i + 2, self.width) {
                        for n in max(j as isize - 1, 0) as usize..min(j + 2, self.height) {
                            if !self.cell[m][n].is_bomb() && !self.cell[m][n].revealed {
                                stack.push((m, n));
                            }
                        }
                    }
                }
            }
        }
    }

    impl Cell {
        pub fn print(&self) {
            print!(
                "{}",
                if self.revealed {
                    match self.content {
                        Empty => ' ',
                        Mine => '*',
                        MineNeighbour { count } => char::from(count + b'0'),
                    }
                } else {
                    match self.mark {
                        Mark::Mine => '?',
                        Mark::None => '.',
                    }
                }
            );
        }

        pub fn is_bomb(&self) -> bool {
            match self.content {
                Mine => true,
                _ => false,
            }
        }
    }
}

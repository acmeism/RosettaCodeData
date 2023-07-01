use rand::{thread_rng, Rng, rngs::ThreadRng};

const WIDTH: usize = 16;
const HEIGHT: usize = 16;

#[derive(Clone, Copy, PartialEq)]
struct Cell {
    col: usize,
    row: usize,
}

impl Cell {
    fn from(col: usize, row: usize) -> Cell {
        Cell {col, row}
    }
}

struct Maze {
    cells: [[bool; HEIGHT]; WIDTH],         //cell visited/non visited
    walls_h: [[bool; WIDTH]; HEIGHT + 1],   //horizontal walls existing/removed
    walls_v: [[bool; WIDTH + 1]; HEIGHT],   //vertical walls existing/removed
    thread_rng: ThreadRng,                  //Random numbers generator
}

impl Maze {

    ///Inits the maze, with all the cells unvisited and all the walls active
    fn new() -> Maze {
        Maze {
            cells: [[true; HEIGHT]; WIDTH],
            walls_h: [[true; WIDTH]; HEIGHT + 1],
            walls_v: [[true; WIDTH + 1]; HEIGHT],
            thread_rng: thread_rng(),
        }
    }

    ///Randomly chooses the starting cell
    fn first(&mut self) -> Cell {
        Cell::from(self.thread_rng.gen_range(0, WIDTH), self.thread_rng.gen_range(0, HEIGHT))
    }

    ///Opens the enter and exit doors
    fn open_doors(&mut self) {
        let from_top: bool = self.thread_rng.gen();
        let limit = if from_top { WIDTH } else { HEIGHT };
        let door = self.thread_rng.gen_range(0, limit);
        let exit = self.thread_rng.gen_range(0, limit);
        if from_top {
            self.walls_h[0][door] = false;
            self.walls_h[HEIGHT][exit] = false;
        } else {
            self.walls_v[door][0] = false;
            self.walls_v[exit][WIDTH] = false;
        }
    }

    ///Removes a wall between the two Cell arguments
    fn remove_wall(&mut self, cell1: &Cell, cell2: &Cell) {
        if cell1.row == cell2.row {
            self.walls_v[cell1.row][if cell1.col > cell2.col { cell1.col } else { cell2.col }] = false;
        } else {
            self.walls_h[if cell1.row > cell2.row { cell1.row } else { cell2.row }][cell1.col] = false;
        };
    }

    ///Returns a random non-visited neighbor of the Cell passed as argument
    fn neighbor(&mut self, cell: &Cell) -> Option<Cell> {
        self.cells[cell.col][cell.row] = false;
        let mut neighbors = Vec::new();
        if cell.col > 0 && self.cells[cell.col - 1][cell.row] { neighbors.push(Cell::from(cell.col - 1, cell.row)); }
        if cell.row > 0 && self.cells[cell.col][cell.row - 1] { neighbors.push(Cell::from(cell.col, cell.row - 1)); }
        if cell.col < WIDTH - 1 && self.cells[cell.col + 1][cell.row] { neighbors.push(Cell::from(cell.col + 1, cell.row)); }
        if cell.row < HEIGHT - 1 && self.cells[cell.col][cell.row + 1] { neighbors.push(Cell::from(cell.col, cell.row + 1)); }
        if neighbors.is_empty() {
            None
        } else {
            let next = neighbors.get(self.thread_rng.gen_range(0, neighbors.len())).unwrap();
            self.remove_wall(cell, next);
            Some(*next)
        }
    }

    ///Builds the maze (runs the Depth-first search algorithm)
    fn build(&mut self) {
        let mut cell_stack: Vec<Cell> = Vec::new();
        let mut next = self.first();
        loop {
            while let Some(cell) = self.neighbor(&next) {
                cell_stack.push(cell);
                next = cell;
            }
            match cell_stack.pop() {
                Some(cell) => next = cell,
                None => break,
            }
        }
    }

    ///MAZE SOLVING: Find the starting cell of the solution
    fn solution_first(&self) -> Option<Cell> {
        for (i, wall) in self.walls_h[0].iter().enumerate() {
            if !wall {
                return Some(Cell::from(i, 0));
            }
        }
        for (i, wall) in self.walls_v.iter().enumerate() {
            if !wall[0] {
                return Some(Cell::from(0, i));
            }
        }
        None
    }

    ///MAZE SOLVING: Find the last cell of the solution
    fn solution_last(&self) -> Option<Cell> {
        for (i, wall) in self.walls_h[HEIGHT].iter().enumerate() {
            if !wall {
                return Some(Cell::from(i, HEIGHT - 1));
            }
        }
        for (i, wall) in self.walls_v.iter().enumerate() {
            if !wall[WIDTH] {
                return Some(Cell::from(WIDTH - 1, i));
            }
        }
        None
    }

    ///MAZE SOLVING: Get the next candidate cell
    fn solution_next(&mut self, cell: &Cell) -> Option<Cell> {
        self.cells[cell.col][cell.row] = false;
        let mut neighbors = Vec::new();
        if cell.col > 0 && self.cells[cell.col - 1][cell.row] && !self.walls_v[cell.row][cell.col] { neighbors.push(Cell::from(cell.col - 1, cell.row)); }
        if cell.row > 0 && self.cells[cell.col][cell.row - 1] && !self.walls_h[cell.row][cell.col] { neighbors.push(Cell::from(cell.col, cell.row - 1)); }
        if cell.col < WIDTH - 1 && self.cells[cell.col + 1][cell.row] && !self.walls_v[cell.row][cell.col + 1] { neighbors.push(Cell::from(cell.col + 1, cell.row)); }
        if cell.row < HEIGHT - 1 && self.cells[cell.col][cell.row + 1] && !self.walls_h[cell.row + 1][cell.col] { neighbors.push(Cell::from(cell.col, cell.row + 1)); }
        if neighbors.is_empty() {
            None
        } else {
            let next = neighbors.get(self.thread_rng.gen_range(0, neighbors.len())).unwrap();
            Some(*next)
        }
    }

    ///MAZE SOLVING: solve the maze
    ///Uses self.cells to store the solution cells (true)
    fn solve(&mut self) {
        self.cells = [[true; HEIGHT]; WIDTH];
        let mut solution: Vec<Cell> = Vec::new();
        let mut next = self.solution_first().unwrap();
        solution.push(next);
        let last = self.solution_last().unwrap();
        'main: loop {
            while let Some(cell) = self.solution_next(&next) {
                solution.push(cell);
                if cell == last {
                    break 'main;
                }
                next = cell;
            }
            solution.pop().unwrap();
            next = *solution.last().unwrap();
        }
        self.cells = [[false; HEIGHT]; WIDTH];
        for cell in solution {
            self.cells[cell.col][cell.row] = true;
        }
    }

    ///MAZE SOLVING: Ask if cell is part of the solution (cells[col][row] == true)
    fn is_solution(&self, col: usize, row: usize) -> bool {
        self.cells[col][row]
    }

    ///Displays a wall
    ///MAZE SOLVING: Leave space for printing '*' if cell is part of the solution
    /// (only when painting vertical walls)
    ///
    // fn paint_wall(h_wall: bool, active: bool) {
    //     if h_wall {
    //         print!("{}", if active { "+---" } else { "+   " });
    //     } else {
    //         print!("{}", if active { "|   " } else { "    " });
    //     }
    // }
    fn paint_wall(h_wall: bool, active: bool, with_solution: bool) {
        if h_wall {
            print!("{}", if active { "+---" } else { "+   " });
        } else {
            print!("{}{}", if active { "|" } else { " " }, if with_solution { "" } else { "   " });
        }
    }

    ///MAZE SOLVING: Paint * if cell is part of the solution
    fn paint_solution(is_part: bool) {
        print!("{}", if is_part { " * " } else {"   "});
    }

    ///Displays a final wall for a row
    fn paint_close_wall(h_wall: bool) {
        if h_wall { println!("+") } else { println!() }
    }

    ///Displays a whole row of walls
    ///MAZE SOLVING: Displays a whole row of walls and, optionally, the included solution cells.
    // fn paint_row(&self, h_walls: bool, index: usize) {
    //     let iter = if h_walls { self.walls_h[index].iter() } else { self.walls_v[index].iter() };
    //     for &wall in iter {
    //         Maze::paint_wall(h_walls, wall);
    //     }
    //     Maze::paint_close_wall(h_walls);
    // }
    fn paint_row(&self, h_walls: bool, index: usize, with_solution: bool) {
        let iter = if h_walls { self.walls_h[index].iter() } else { self.walls_v[index].iter() };
        for (col, &wall) in iter.enumerate() {
            Maze::paint_wall(h_walls, wall, with_solution);
            if !h_walls && with_solution && col < WIDTH  {
                Maze::paint_solution(self.is_solution(col, index));
            }
        }
        Maze::paint_close_wall(h_walls);
    }

    ///Paints the maze
    ///MAZE SOLVING: Displaying the solution is an option
    // fn paint(&self) {
    //     for i in 0 .. HEIGHT {
    //         self.paint_row(true, i);
    //         self.paint_row(false, i);
    //     }
    //     self.paint_row(true, HEIGHT);
    // }
    fn paint(&self, with_solution: bool) {
        for i in 0 .. HEIGHT {
            self.paint_row(true, i, with_solution);
            self.paint_row(false, i, with_solution);
        }
        self.paint_row(true, HEIGHT, with_solution);
    }
}

fn main() {
    let mut maze = Maze::new();
    maze.build();
    maze.open_doors();

    println!("The maze:");
    maze.paint(false);

    maze.solve();
    println!("The maze, solved:");
    maze.paint(true);
}

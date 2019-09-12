use std::collections::HashMap;
use std::collections::HashSet;

type Cell = (i32, i32);
type Colony = HashSet<Cell>;

fn print_colony(col: &Colony, width: i32, height: i32) {
    for y in 0..height {
        for x in 0..width {
            print!("{} ",
                if col.contains(&(x, y)) {"O"}
                else {"."}
            );
        }
        println!();
    }
}

fn neighbours(&(x,y): &Cell) -> Vec<Cell> {
    vec![
        (x-1,y-1), (x,y-1), (x+1,y-1),
        (x-1,y),            (x+1,y),
        (x-1,y+1), (x,y+1), (x+1,y+1),
    ]
}

fn neighbour_counts(col: &Colony) -> HashMap<Cell, i32> {
    let mut ncnts = HashMap::new();
    for cell in col.iter().flat_map(neighbours) {
        *ncnts.entry(cell).or_insert(0) += 1;
    }
    ncnts
}

fn generation(col: Colony) -> Colony {
    neighbour_counts(&col)
        .into_iter()
        .filter_map(|(cell, cnt)|
            match (cnt, col.contains(&cell)) {
                (2, true) |
                (3, ..) => Some(cell),
                _ => None
        })
        .collect()
}

fn life(init: Vec<Cell>, iters: i32, width: i32, height: i32) {
    let mut col: Colony = init.into_iter().collect();
    for i in 0..iters+1
    {
        println!("({})", &i);
        if i != 0 {
            col = generation(col);
        }
        print_colony(&col, width, height);
    }
}

fn main() {
    let blinker = vec![
        (1,0),
        (1,1),
        (1,2)];

    life(blinker, 3, 3, 3);

    let glider = vec![
                (1,0),
                        (2,1),
        (0,2),  (1,2),  (2,2)];

    life(glider, 20, 8, 8);
}

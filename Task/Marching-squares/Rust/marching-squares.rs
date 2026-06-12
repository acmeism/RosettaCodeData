use std::process;

// Direction constants
#[derive(Clone, Copy, PartialEq)]
enum Direction {
    E = 0,
    N = 1,
    W = 2,
    S = 3,
}

// X generates coordinate pairs for a grid of given dimensions
fn x(a: usize, b: usize) -> Vec<Vec<usize>> {
    let mut c = Vec::new();
    for aa in 0..=a {
        for bb in 0..=b {
            c.push(vec![aa, bb]);
        }
    }
    c
}

// any checks if any element in the slice equals val
fn any(arr: &[i32], val: i32) -> bool {
    arr.iter().any(|&v| v == val)
}

// identify_perimeter identifies the perimeter of a shape in a 2D matrix
fn identify_perimeter(data: &[Vec<i32>]) -> (usize, i32, String) {
    let coords = x(data[0].len() - 1, data.len() - 1);

    for coord in coords {
        let x = coord[0];
        let y = coord[1];

        if y < data.len() && x < data[0].len() && data[y][x] != 0 {
            let mut path = String::new();
            let mut cx = x;
            let mut cy = y;
            let mut d = Direction::E;
            let mut p = Direction::E;

            loop {
                let mut mask = 0;

                // Check 2x2 neighborhood
                let offsets = [(0, 0, 1), (1, 0, 2), (0, 1, 4), (1, 1, 8)];
                for (dx, dy, b) in offsets {
                    let mx = cx + dx;
                    let my = cy + dy;

                    if mx > 0 && my > 0 && my - 1 < data.len() && mx - 1 < data[0].len() &&
                        data[my - 1][mx - 1] != 0 {
                        mask += b;
                    }
                }

                // Determine direction based on mask
                if any(&[1, 5, 13], mask) {
                    d = Direction::N;
                }
                if any(&[2, 3, 7], mask) {
                    d = Direction::E;
                }
                if any(&[4, 12, 14], mask) {
                    d = Direction::W;
                }
                if any(&[8, 10, 11], mask) {
                    d = Direction::S;
                }
                if mask == 6 {
                    if p == Direction::N {
                        d = Direction::W;
                    } else {
                        d = Direction::E;
                    }
                }
                if mask == 9 {
                    if p == Direction::E {
                        d = Direction::N;
                    } else {
                        d = Direction::S;
                    }
                }

                // Add direction character to path
                let dir_chars = ['E', 'N', 'W', 'S'];
                path.push(dir_chars[d as usize]);
                p = d;

                // Move in the determined direction
                let dx_vals = [1i32, 0, -1, 0];
                let dy_vals = [0i32, -1, 0, 1];

                cx = (cx as i32 + dx_vals[d as usize]) as usize;
                cy = (cy as i32 + dy_vals[d as usize]) as usize;

                // Check if we've returned to starting position
                if cx == x && cy == y {
                    break;
                }
            }

            return (x, -(y as i32), path);
        }
    }

    println!("That did not work out...");
    process::exit(1);
}

fn main() {
    let m = vec![
        vec![0, 0, 0, 0, 0],
        vec![0, 0, 0, 0, 0],
        vec![0, 0, 1, 1, 0],
        vec![0, 0, 1, 1, 0],
        vec![0, 0, 0, 1, 0],
        vec![0, 0, 0, 0, 0],
    ];

    let (x, y, path) = identify_perimeter(&m);
    println!("X: {}, Y: {}, Path: {}", x, y, path);
}

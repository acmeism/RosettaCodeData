const VECTORS: [(isize, isize); 4] = [(1, 0), (0, 1), (-1, 0), (0, -1)];

pub fn spiral_matrix(size: usize) -> Vec<Vec<u32>> {
    let mut matrix = vec![vec![0; size]; size];
    let mut movement = VECTORS.iter().cycle();
    let (mut x, mut y, mut n) = (-1, 0, 1..);

    for (move_x, move_y) in std::iter::once(size)
        .chain((1..size).rev().flat_map(|n| std::iter::repeat(n).take(2)))
        .flat_map(|steps| std::iter::repeat(movement.next().unwrap()).take(steps))
    {
        x += move_x;
        y += move_y;
        matrix[y as usize][x as usize] = n.next().unwrap();
    }

    matrix
}

fn main() {
    for i in spiral_matrix(4).iter() {
        for j in i.iter() {
            print!("{:>2} ", j);
        }
        println!();
    }
}

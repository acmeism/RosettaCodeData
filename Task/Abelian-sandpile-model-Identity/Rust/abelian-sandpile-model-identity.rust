#[derive(Clone)]
struct Box {
    piles: [[u8; 3]; 3],
}

impl Box {
    fn init(piles: [[u8; 3]; 3]) -> Box {
        let a = Box { piles };

        if a.piles.iter().any(|&row| row.iter().any(|&pile| pile >= 4)) {
            return a.avalanche();
        } else {
            return a;
        }
    }

    fn avalanche(&self) -> Box {
        let mut a = self.clone();
        for (i, row) in self.piles.iter().enumerate() {
            for (j, pile) in row.iter().enumerate() {
                if *pile >= 4u8 {
                    if i > 0 {
                        a.piles[i - 1][j] += 1u8
                    }
                    if i < 2 {
                        a.piles[i + 1][j] += 1u8
                    }
                    if j > 0 {
                        a.piles[i][j - 1] += 1u8
                    }
                    if j < 2 {
                        a.piles[i][j + 1] += 1u8
                    }
                    a.piles[i][j] -= 4;
                }
            }
        }
        Box::init(a.piles)
    }

    fn add(&self, a: &Box) -> Box {
        let mut b = Box {
            piles: [[0u8; 3]; 3],
        };
        for (row, columns) in b.piles.iter_mut().enumerate() {
            for (col, pile) in columns.iter_mut().enumerate() {
                *pile = self.piles[row][col] + a.piles[row][col]
            }
        }
        Box::init(b.piles)
    }
}

fn main() {
    println!(
        "The piles demonstration avalanche starts as:\n{:?}\n{:?}\n{:?}",
        [4, 3, 3],
        [3, 1, 2],
        [0, 2, 3]
    );
    let s0 = Box::init([[4u8, 3u8, 3u8], [3u8, 1u8, 2u8], [0u8, 2u8, 3u8]]);
    println!(
        "And ends as:\n{:?}\n{:?}\n{:?}",
        s0.piles[0], s0.piles[1], s0.piles[2]
    );
    let s1 = Box::init([[1u8, 2u8, 0u8], [2u8, 1u8, 1u8], [0u8, 1u8, 3u8]]);
    let s2 = Box::init([[2u8, 1u8, 3u8], [1u8, 0u8, 1u8], [0u8, 1u8, 0u8]]);
    let s1_2 = s1.add(&s2);
    let s2_1 = s2.add(&s1);
    println!(
        "The piles in s1 + s2 are:\n{:?}\n{:?}\n{:?}",
        s1_2.piles[0], s1_2.piles[1], s1_2.piles[2]
    );
    println!(
        "The piles in s2 + s1 are:\n{:?}\n{:?}\n{:?}",
        s2_1.piles[0], s2_1.piles[1], s2_1.piles[2]
    );
    let s3 = Box::init([[3u8; 3]; 3]);
    let s3_id = Box::init([[2u8, 1u8, 2u8], [1u8, 0u8, 1u8], [2u8, 1u8, 2u8]]);
    let s4 = s3.add(&s3_id);
    println!(
        "The piles in s3 + s3_id are:\n{:?}\n{:?}\n{:?}",
        s4.piles[0], s4.piles[1], s4.piles[2]
    );
    let s5 = s3_id.add(&s3_id);
    println!(
        "The piles in s3_id + s3_id are:\n{:?}\n{:?}\n{:?}",
        s5.piles[0], s5.piles[1], s5.piles[2]
    );
}

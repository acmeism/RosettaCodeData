use std::collections::LinkedList;
use std::iter::IntoIterator;

fn main() {
    for (n, s) in NQueens::new(8).enumerate() {
        println!("Solution #{}:\n{}\n", n + 1, s.to_string());
    }
}

fn permutations<'a, T, I>(collection: I) -> Box<Iterator<dyn Item=LinkedList<T>> + 'a>
    where I: 'a + IntoIterator<Item=T> + Clone,
          T: 'a + PartialEq + Copy + Clone {
    if collection.clone().into_iter().count() == 0 {
        Box::new(vec![LinkedList::new()].into_iter())
    }
    else {
        Box::new(
            collection.clone().into_iter().flat_map(move |i| {
                permutations(collection.clone().into_iter()
                    .filter(move |&i0| i != i0)
                    .collect::<Vec<_>>())
                    .map(move |mut l| {l.push_front(i); l})
            })
        )
    }
}

pub struct NQueens {
    iterator: Box<Iterator<dyn Item=NQueensSolution>>
}

impl NQueens {
    pub fn new(n: u32) -> NQueens {
        NQueens {
            iterator: Box::new(permutations(0..n)
                .filter(|vec| {
                    let iter = vec.iter().enumerate();
                    iter.clone().all(|(col, &row)| {
                        iter.clone().filter(|&(c,_)| c != col)
                            .all(|(ocol, &orow)| {
                            col as i32 - row as i32 !=
                                ocol as i32 - orow as i32 &&
                            col as u32 + row != ocol as u32 + orow
                        })
                    })
                })
                .map(|vec| NQueensSolution(vec))
            )
        }
    }
}

impl Iterator for NQueens {
    type Item = NQueensSolution;
    fn next(&mut self) -> Option<NQueensSolution> {
        self.iterator.next()
    }
}

pub struct NQueensSolution(LinkedList<u32>);

impl ToString for NQueensSolution {
    fn to_string(&self) -> String {
        let mut str = String::new();
        for &row in self.0.iter() {
            for r in 0..self.0.len() as u32 {
                if r == row {
                    str.push_str("Q ");
                } else {
                    str.push_str("- ");
                }
            }
            str.push('\n');
        }
        str
    }
}

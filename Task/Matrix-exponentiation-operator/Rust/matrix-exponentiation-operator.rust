use std::fmt;
use std::ops;
const WIDTH: usize = 6;

#[derive(Clone)]
struct SqMat {
    data: Vec<Vec<i64>>,
}

impl fmt::Debug for SqMat {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let mut row = "".to_string();
        for i in &self.data {
            for j in i {
                row += &format!("{:>w$} ", j, w = WIDTH);
            }
            row += &"\n";
        }
        write!(f, "{}", row)
    }
}

impl ops::BitXor<u32> for SqMat {
    type Output = Self;

    fn bitxor(self, n: u32) -> Self::Output {
        let mut aux = self.data.clone();
        let mut ans: SqMat = SqMat {
            data: vec![vec![0; aux.len()]; aux.len()],
        };
        for i in 0..aux.len() {
            ans.data[i][i] = 1;
        }
        let mut b = n;
        while b > 0 {
            if b & 1 > 0 {
                // ans = ans * aux
                let mut tmp = aux.clone();
                for i in 0..aux.len() {
                    for j in 0..aux.len() {
                        tmp[i][j] = 0;
                        for k in 0..aux.len() {
                            tmp[i][j] += ans.data[i][k] * aux[k][j];
                        }
                    }
                }
                ans.data = tmp;
            }
            b >>= 1;
            if b > 0 {
                // aux = aux * aux
                let mut tmp = aux.clone();
                for i in 0..aux.len() {
                    for j in 0..aux.len() {
                        tmp[i][j] = 0;
                        for k in 0..aux.len() {
                            tmp[i][j] += aux[i][k] * aux[k][j];
                        }
                    }
                }
                aux = tmp;
            }
        }
        ans
    }
}

fn main() {
    let sm: SqMat = SqMat {
        data: vec![vec![1, 2, 0], vec![0, 3, 1], vec![1, 0, 0]],
    };
    for i in 0..11 {
        println!("Power of {}:\n{:?}", i, sm.clone() ^ i);
    }
}

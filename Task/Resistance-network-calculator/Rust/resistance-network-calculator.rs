use itertools::Itertools;
use num_rational::Ratio;
use num_traits::sign::Signed;
use std::str::FromStr;

fn gauss(m: &mut Vec<Vec<Ratio<i64>>>) -> Vec<Ratio<i64>> {
    let (n, p) = (m.len(), m[0].len());
    for i in 0..n {
        let k = (i..n)
            .reduce(|x, y| if m[y][i].abs() > m[x][i].abs() { y } else { x })
            .unwrap_or(0);
        let tmp = m[i].clone();
        m[i] = m[k].clone();
        m[k] = tmp;
        let mut t = Ratio::<i64>::new(*m[i][i].denom(), *m[i][i].numer());
        for j in i + 1..p {
            m[i][j] *= t;
        }
        for j in i + 1..n {
            t = m[j][i];
            for k in i + 1..p {
                let tmp = m[i][k];
                m[j][k] -= t * tmp;
            }
        }
    }
    for i in (0..n).rev() {
        for j in 0..i {
            let end = m[j].len() - 1;
            let y = m[i][end];
            let x = m[j][i];
            m[j][end] -= x * y;
        }
    }
    return m.into_iter().map(|row| row[row.len() - 1]).collect_vec();
}

fn network(n: usize, k0: usize, k1: usize, s: &str) -> Ratio<i64> {
    let mut m = vec![vec![Ratio::<i64>::new(0, 1); n + 1]; n];
    let resistors: Vec<&str> = s.split("|").collect();
    for resistor in resistors {
        let [astr, bstr, rstr] = resistor.split(" ").collect_vec()[0..3] else {
            todo!()
        };
        let (a, b, r) = (
            usize::from_str(astr).unwrap(),
            usize::from_str(bstr).unwrap(),
            Ratio::<i64>::new(1, i64::from_str(rstr).unwrap()),
        ); // parse(Int, rstr)
        m[a][a] += r;
        m[b][b] += r;
        if a > 0 {
            m[a][b] -= r
        }
        if b > 0 {
            m[b][a] -= r
        }
    }
    let end = m[k1].len() - 1;
    (m[k0][k0], m[k1][end]) = (Ratio::<i64>::new(1, 1), Ratio::<i64>::new(1, 1));
    return gauss(&mut m)[k1];
}

fn main() {
    assert!(Ratio::<i64>::new(10, 1) == network(7, 0, 1, "0 2 6|2 3 4|3 4 10|4 5 2|5 6 8|6 1 4|3 5 6|3 6 6|3 1 8|2 1 8"));
    assert!(Ratio::<i64>::new(3, 2) == network(3 * 3, 0, 3 * 3 - 1, "0 1 1|1 2 1|3 4 1|4 5 1|6 7 1|7 8 1|0 3 1|3 6 1|1 4 1|4 7 1|2 5 1|5 8 1"));
    assert!(Ratio::<i64>::new(13, 7) == network(4*4,0,4*4-1,"0 1 1|1 2 1|2 3 1|4 5 1|5 6 1|6 7 1|8 9 1|9 10 1|10 11 1|12 13 1|13 14 1|14 15 1|0 4 1|4 8 1|8 12 1|1 5 1|5 9 1|9 13 1|2 6 1|6 10 1|10 14 1|3 7 1|7 11 1|11 15 1"));
    assert!(Ratio::<i64>::new(180, 1) == network(4, 0, 3, "0 1 150|0 2 50|1 3 300|2 3 250"));
}

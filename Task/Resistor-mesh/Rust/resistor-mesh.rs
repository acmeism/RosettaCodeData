use std::fmt;

#[derive(Clone, Copy)]
struct Node {
    v: f64,
    fixed: i32,
}

impl Node {
    fn new() -> Self {
        Node { v: 0.0, fixed: 0 }
    }

    fn new_with_values(v: f64, fixed: i32) -> Self {
        Node { v, fixed }
    }

    fn get_v(&self) -> f64 {
        self.v
    }

    fn set_v(&mut self, nv: f64) {
        self.v = nv;
    }

    fn get_fixed(&self) -> i32 {
        self.fixed
    }

    fn set_fixed(&mut self, nf: i32) {
        self.fixed = nf;
    }
}

impl fmt::Display for Node {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Node {{ v: {}, fixed: {} }}", self.v, self.fixed)
    }
}

fn set_boundary(m: &mut Vec<Vec<Node>>) {
    m[1][1].set_v(1.0);
    m[1][1].set_fixed(1);

    m[6][7].set_v(-1.0);
    m[6][7].set_fixed(-1);
}

fn calculate_difference(
    m: &Vec<Vec<Node>>,
    d: &mut Vec<Vec<Node>>,
    w: usize,
    h: usize,
) -> f64 {
    let mut total = 0.0;
    for i in 0..h {
        for j in 0..w {
            let mut v = 0.0;
            let mut n = 0;
            if i > 0 {
                v += m[i - 1][j].get_v();
                n += 1;
            }
            if j > 0 {
                v += m[i][j - 1].get_v();
                n += 1;
            }
            if i + 1 < h {
                v += m[i + 1][j].get_v();
                n += 1;
            }
            if j + 1 < w {
                v += m[i][j + 1].get_v();
                n += 1;
            }
            let val = m[i][j].get_v() - v / n as f64;
            d[i][j].set_v(val);
            if m[i][j].get_fixed() == 0 {
                total += val * val;
            }
        }
    }
    total
}

fn iter(m: &mut Vec<Vec<Node>>, w: usize, h: usize) -> f64 {
    let mut d: Vec<Vec<Node>> = vec![vec![Node::new(); w]; h];

    let mut curr: [f64; 3] = [0.0, 0.0, 0.0];
    let mut diff = 1e10;

    while diff > 1e-24 {
        set_boundary(m);
        diff = calculate_difference(m, &mut d, w, h);
        for i in 0..h {
            for j in 0..w {
                let current_v = m[i][j].get_v();
                let diff_v = d[i][j].get_v();
                m[i][j].set_v(current_v - diff_v);
            }
        }
    }

    for i in 0..h {
        for j in 0..w {
            let mut k = 0;
            if i != 0 {
                k += 1;
            }
            if j != 0 {
                k += 1;
            }
            if i < h - 1 {
                k += 1;
            }
            if j < w - 1 {
                k += 1;
            }
            curr[(m[i][j].get_fixed() + 1) as usize] += d[i][j].get_v() * k as f64;
        }
    }

    (curr[2] - curr[0]) / 2.0
}

const S: usize = 10;

fn main() {
    let mut mesh: Vec<Vec<Node>> = vec![vec![Node::new(); S]; S];

    let r = 2.0 / iter(&mut mesh, S, S);
    println!("R = {:.15}", r);
}

use std::fmt;

// Define a wrapper struct for Vec<T>
struct DisplayVec<T>(Vec<T>);

impl<T> DisplayVec<T> {
    fn new(vec: Vec<T>) -> Self {
        DisplayVec(vec)
    }
}


// Implement the Display trait for the wrapper struct
impl<T: fmt::Display> fmt::Display for DisplayVec<T> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "[")?;
        if let Some((first, rest)) = self.0.split_first() {
            write!(f, "{}", first)?;
            for elem in rest {
                write!(f, ", {}", elem)?;
            }
        }
        write!(f, "]")
    }
}

fn kosaraju(g: &mut Vec<Vec<usize>>) -> Vec<usize> {
    let size = g.len();
    let mut vis = vec![false; size]; // all false by default
    let mut l = vec![0; size]; // all zero by default
    let mut x = size; // index for filling l in reverse order
    let mut t = vec![vec![]; size]; // transpose graph

    // Recursive subroutine 'visit':
    fn visit(u: usize, g: &Vec<Vec<usize>>, vis: &mut Vec<bool>, l: &mut Vec<usize>, x: &mut usize, t: &mut Vec<Vec<usize>>) {
        if !vis[u] {
            vis[u] = true;
            for &v in &g[u] {
                visit(v, g, vis, l, x, t);
                t[v].push(u); // construct transpose
            }
            *x -= 1;
            l[*x] = u;
        }
    }

    // 2. For each vertex u of the graph do visit(u)
    for i in 0..g.len() {
        visit(i, g, &mut vis, &mut l, &mut x, &mut t);
    }

    let mut c = vec![0; size]; // used for component assignment
    vis = vec![true; size];   //repurpose vis to mean 'unassigned'

    // Recursive subroutine 'assign':
    fn assign(u: usize, root: usize, t: &Vec<Vec<usize>>, vis: &mut Vec<bool>, c: &mut Vec<usize>) {
        if vis[u] {
            vis[u] = false;
            c[u] = root;
            for &v in &t[u] {
                assign(v, root, t, vis, c);
            }
        }
    }

    // 3: For each element u of l in order, do assign(u, u)
    for &u in &l {
        if vis[u] {
            assign(u, u, &t, &mut vis, &mut c);
        }

    }

    c
}

fn main() {
    let mut g = vec![
        vec![1],
        vec![2],
        vec![0],
        vec![1, 2, 4],
        vec![3, 5],
        vec![2, 6],
        vec![5],
        vec![4, 6, 7],
    ];

    let result = kosaraju(&mut g);
    println!("{}", DisplayVec::new(result));
}

pub type Edge = (usize, usize);

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub struct Graph<T> {
    size: usize,
    edges: Vec<Option<T>>,
}

impl<T> Graph<T> {
    pub fn new(size: usize) -> Self {
        Self {
            size,
            edges: std::iter::repeat_with(|| None).take(size * size).collect(),
        }
    }

    pub fn new_with(size: usize, f: impl FnMut(Edge) -> Option<T>) -> Self {
        let edges = (0..size)
            .flat_map(|i| (0..size).map(move |j| (i, j)))
            .map(f)
            .collect();

        Self { size, edges }
    }

    pub fn with_diagonal(mut self, mut f: impl FnMut(usize) -> Option<T>) -> Self {
        self.edges
            .iter_mut()
            .step_by(self.size + 1)
            .enumerate()
            .for_each(move |(vertex, edge)| *edge = f(vertex));

        self
    }

    pub fn size(&self) -> usize {
        self.size
    }

    pub fn edge(&self, edge: Edge) -> &Option<T> {
        let index = self.edge_index(edge);
        &self.edges[index]
    }

    pub fn edge_mut(&mut self, edge: Edge) -> &mut Option<T> {
        let index = self.edge_index(edge);
        &mut self.edges[index]
    }

    fn edge_index(&self, (row, col): Edge) -> usize {
        assert!(row < self.size && col < self.size);
        row * self.size() + col
    }
}

impl<T> std::ops::Index<Edge> for Graph<T> {
    type Output = Option<T>;

    fn index(&self, index: Edge) -> &Self::Output {
        self.edge(index)
    }
}

impl<T> std::ops::IndexMut<Edge> for Graph<T> {
    fn index_mut(&mut self, index: Edge) -> &mut Self::Output {
        self.edge_mut(index)
    }
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Paths(Graph<usize>);

impl Paths {
    pub fn new<T>(graph: &Graph<T>) -> Self {
        Self(Graph::new_with(graph.size(), |(i, j)| {
            graph[(i, j)].as_ref().map(|_| j)
        }))
    }

    pub fn vertices(&self, from: usize, to: usize) -> Path<'_> {
        assert!(from < self.0.size() && to < self.0.size());

        Path {
            graph: &self.0,
            from: Some(from),
            to,
        }
    }

    fn update(&mut self, from: usize, to: usize, via: usize) {
        self.0[(from, to)] = self.0[(from, via)];
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Path<'a> {
    graph: &'a Graph<usize>,
    from: Option<usize>,
    to: usize,
}

impl<'a> Iterator for Path<'a> {
    type Item = usize;

    fn next(&mut self) -> Option<Self::Item> {
        self.from.map(|from| {
            let result = from;

            self.from = if result != self.to {
                self.graph[(result, self.to)]
            } else {
                None
            };

            result
        })
    }
}

pub fn floyd_warshall<W>(mut result: Graph<W>) -> (Graph<W>, Option<Paths>)
where
    W: Copy + std::ops::Add<W, Output = W> + std::cmp::Ord + Default,
{
    let mut without_negative_cycles = true;
    let mut paths = Paths::new(&result);
    let n = result.size();

    for k in 0..n {
        for i in 0..n {
            for j in 0..n {
                // Negative cycle detection with T::default as the negative boundary
                if i == j && result[(i, j)].filter(|&it| it < W::default()).is_some() {
                    without_negative_cycles = false;
                    continue;
                }

                if let (Some(ik_weight), Some(kj_weight)) = (result[(i, k)], result[(k, j)]) {
                    let ij_edge = result.edge_mut((i, j));
                    let ij_weight = ik_weight + kj_weight;

                    if ij_edge.is_none() {
                        *ij_edge = Some(ij_weight);
                        paths.update(i, j, k);
                    } else {
                        ij_edge
                            .as_mut()
                            .filter(|it| ij_weight < **it)
                            .map_or((), |it| {
                                *it = ij_weight;
                                paths.update(i, j, k);
                            });
                    }
                }
            }
        }
    }

    (result, Some(paths).filter(|_| without_negative_cycles)) // No paths for negative cycles
}

fn format_path<T: ToString>(path: impl Iterator<Item = T>) -> String {
    path.fold(String::new(), |mut acc, x| {
        if !acc.is_empty() {
            acc.push_str(" -> ");
        }

        acc.push_str(&x.to_string());
        acc
    })
}

fn print_results<W, V>(weights: &Graph<W>, paths: Option<&Paths>, vertex: impl Fn(usize) -> V)
where
    W: std::fmt::Display + Default + Eq,
    V: std::fmt::Display,
{
    let n = weights.size();

    for from in 0..n {
        for to in 0..n {
            if let Some(weight) = &weights[(from, to)] {
                // Skip trivial information (i.e., default weight on the diagonal)
                if from == to && *weight == W::default() {
                    continue;
                }

                println!(
                    "{} -> {}: {} \t{}",
                    vertex(from),
                    vertex(to),
                    weight,
                    format_path(paths.iter().flat_map(|p| p.vertices(from, to)).map(&vertex))
                );
            }
        }
    }
}

fn main() {
    let graph = {
        let mut g = Graph::new(4).with_diagonal(|_| Some(0));
        g[(0, 2)] = Some(-2);
        g[(1, 0)] = Some(4);
        g[(1, 2)] = Some(3);
        g[(2, 3)] = Some(2);
        g[(3, 1)] = Some(-1);
        g
    };

    let (weights, paths) = floyd_warshall(graph);
    // Fixup the vertex name (as we use zero-based indices)
    print_results(&weights, paths.as_ref(), |index| index + 1);
}

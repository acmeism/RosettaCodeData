use std::collections::VecDeque;

#[derive(Clone, Copy, PartialEq)]
struct Point {
    x: i32,
    y: i32,
}

impl Point {
    fn new(x: i32, y: i32) -> Self {
        Point { x, y }
    }

    fn add(&self, other: &Point) -> Point {
        Point {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

#[derive(Clone)]  // Added Clone trait
struct Map {
    m: [[u8; 8]; 8],
    w: i32,
    h: i32,
}

impl Map {
    fn new() -> Self {
        let t = [
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 1, 1, 1, 0],
            [0, 0, 1, 0, 0, 0, 1, 0],
            [0, 0, 1, 0, 0, 0, 1, 0],
            [0, 0, 1, 1, 1, 1, 1, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
        ];
        Map {
            m: t,
            w: 8,
            h: 8,
        }
    }

    fn get(&self, x: i32, y: i32) -> u8 {
        self.m[y as usize][x as usize]
    }
}

#[derive(Clone)]
struct Node {
    pos: Point,
    parent: Point,
    dist: i32,
    cost: i32,
}

impl PartialEq for Node {
    fn eq(&self, other: &Self) -> bool {
        self.pos == other.pos
    }
}

struct AStar {
    m: Map,
    end: Point,
    start: Point,
    neighbours: [Point; 8],
    open: Vec<Node>,
    closed: Vec<Node>,
}

impl AStar {
    fn new() -> Self {
        AStar {
            m: Map::new(),
            end: Point::new(0, 0),
            start: Point::new(0, 0),
            neighbours: [
                Point::new(-1, -1), Point::new(1, -1),
                Point::new(-1, 1), Point::new(1, 1),
                Point::new(0, -1), Point::new(-1, 0),
                Point::new(0, 1), Point::new(1, 0),
            ],
            open: Vec::new(),
            closed: Vec::new(),
        }
    }

    fn calc_dist(&self, p: &Point) -> i32 {
        let x = self.end.x - p.x;
        let y = self.end.y - p.y;
        x * x + y * y
    }

    fn is_valid(&self, p: &Point) -> bool {
        p.x >= 0 && p.y >= 0 && p.x < self.m.w && p.y < self.m.h
    }

    fn exist_point(&self, p: &Point, cost: i32) -> bool {  // Changed to immutable borrow
        if let Some(i) = self.closed.iter().position(|n| n.pos == *p) {
            if self.closed[i].cost + self.closed[i].dist < cost {
                return true;
            }
        }
        if let Some(i) = self.open.iter().position(|n| n.pos == *p) {
            if self.open[i].cost + self.open[i].dist < cost {
                return true;
            }
        }
        false
    }

    fn fill_open(&mut self, n: &Node) -> bool {
        for (x, &neighbour) in self.neighbours.iter().enumerate() {
            let step_cost = if x < 4 { 1 } else { 1 };
            let neighbour_pos = n.pos.add(&neighbour);

            if neighbour_pos == self.end {
                return true;
            }

            if self.is_valid(&neighbour_pos) && self.m.get(neighbour_pos.x, neighbour_pos.y) != 1 {
                let nc = step_cost + n.cost;
                let dist = self.calc_dist(&neighbour_pos);
                if !self.exist_point(&neighbour_pos, nc + dist) {
                    self.open.push(Node {
                        cost: nc,
                        dist,
                        pos: neighbour_pos,
                        parent: n.pos,
                    });
                }
            }
        }
        false
    }

    fn search(&mut self, s: Point, e: Point, m: Map) -> bool {
        self.end = e;
        self.start = s;
        self.m = m;

        let dist = self.calc_dist(&s);
        self.open.push(Node {
            cost: 0,
            pos: s,
            parent: Point::new(0, 0),
            dist,
        });

        while !self.open.is_empty() {
            self.open.sort_by(|a, b| (a.dist + a.cost).cmp(&(b.dist + b.cost)));
            let n = self.open.remove(0);
            self.closed.push(n.clone());
            if self.fill_open(&n) {
                return true;
            }
        }
        false
    }

    fn path(&self) -> (Vec<Point>, i32) {
        let mut path = VecDeque::new();
        path.push_front(self.end);
        let cost = 1 + self.closed.last().unwrap().cost;
        path.push_front(self.closed.last().unwrap().pos);
        let mut parent = self.closed.last().unwrap().parent;

        for node in self.closed.iter().rev() {
            if node.pos == parent && node.pos != self.start {
                path.push_front(node.pos);
                parent = node.parent;
            }
        }
        path.push_front(self.start);
        (path.into_iter().collect(), cost)
    }
}

fn main() {
    let m = Map::new();
    let s = Point::new(0, 0);
    let e = Point::new(7, 7);
    let mut astar = AStar::new();

    if astar.search(s, e, m.clone()) {  // Clone the map here
        let (path, c) = astar.path();

        for y in -1..9 {
            for x in -1..9 {
                if x < 0 || y < 0 || x > 7 || y > 7 || m.get(x, y) == 1 {
                    print!("#");
                } else if path.contains(&Point::new(x, y)) {
                    print!("x");
                } else {
                    print!(".");
                }
            }
            println!();
        }

        println!("\nPath cost {}:", c);
        for p in path {
            print!("({}, {}) ", p.x, p.y);
        }
        println!();
    }
    println!();
}

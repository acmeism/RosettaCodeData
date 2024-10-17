use std::str::FromStr;

#[derive(Debug, Copy, Clone, PartialEq)]
pub enum State {
    Empty,
    Conductor,
    ElectronTail,
    ElectronHead,
}

impl State {
    fn next(&self, e_nearby: usize) -> State {
        match self {
            State::Empty => State::Empty,
            State::Conductor => {
                if e_nearby == 1 || e_nearby == 2 {
                    State::ElectronHead
                } else {
                    State::Conductor
                }
            }
            State::ElectronTail => State::Conductor,
            State::ElectronHead => State::ElectronTail,
        }
    }
}

#[derive(Debug, Clone, PartialEq)]
pub struct WireWorld {
    pub width: usize,
    pub height: usize,
    pub data: Vec<State>,
}

impl WireWorld {
    pub fn new(width: usize, height: usize) -> Self {
        WireWorld {
            width,
            height,
            data: vec![State::Empty; width * height],
        }
    }

    pub fn get(&self, x: usize, y: usize) -> Option<State> {
        if x >= self.width || y >= self.height {
            None
        } else {
            self.data.get(y * self.width + x).copied()
        }
    }

    pub fn set(&mut self, x: usize, y: usize, state: State) {
        self.data[y * self.width + x] = state;
    }

    fn neighbors<F>(&self, x: usize, y: usize, mut f: F) -> usize
        where F: FnMut(State) -> bool
    {
        let (x, y) = (x as i32, y as i32);
        let neighbors = [(x-1,y-1),(x-1,y),(x-1,y+1),(x,y-1),(x,y+1),(x+1,y-1),(x+1,y),(x+1,y+1)];

        neighbors.iter().filter_map(|&(x, y)| self.get(x as usize, y as usize)).filter(|&s| f(s)).count()
    }

    pub fn next(&mut self) {
        let mut next_state = vec![];
        for y in 0..self.height {
            for x in 0..self.width {
                let e_count = self.neighbors(x, y, |e| e == State::ElectronHead);
                next_state.push(self.get(x, y).unwrap().next(e_count));
            }
        }
        self.data = next_state;
    }
}

impl FromStr for WireWorld {
    type Err = ();
    fn from_str(s: &str) -> Result<WireWorld, ()> {
        let s = s.trim();
        let height = s.lines().count();
        let width = s.lines().map(|l| l.trim_end().len()).max().unwrap_or(0);
        let mut world = WireWorld::new(width, height);

        for (y, line) in s.lines().enumerate() {
            for (x, ch) in line.trim_end().chars().enumerate() {
                let state = match ch {
                    '.' => State::Conductor,
                    't' => State::ElectronTail,
                    'H' => State::ElectronHead,
                    _ => State::Empty,
                };
                world.set(x, y, state);
            }
        }
        Ok(world)
    }
}

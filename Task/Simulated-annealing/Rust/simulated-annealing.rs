// Add this to Cargo.toml:
// [dependencies]
// rand = "0.8"

use std::f64;
use rand::prelude::*;
use rand::distributions::Uniform;

type Coord = (i32, i32);
const NUM_CITIES: usize = 100;

// CityID with member functions to get position
#[derive(Debug, Clone, Copy, PartialEq)]
struct CityID {
    v: i32,
}

impl CityID {
    fn new() -> Self {
        CityID { v: -1 }
    }

    fn from_int(i: i32) -> Self {
        CityID { v: i }
    }

    fn from_coord(ij: Coord) -> Result<Self, String> {
        if ij.0 < 0 || ij.0 > 9 || ij.1 < 0 || ij.1 > 9 {
            return Err("Cannot construct CityID from invalid coordinates!".to_string());
        }
        Ok(CityID { v: ij.0 * 10 + ij.1 })
    }

    fn get_pos(&self) -> Coord {
        (self.v / 10, self.v % 10)
    }
}

// Function for distance between two cities
fn dist_coords(city1: Coord, city2: Coord) -> f64 {
    let diffx = (city1.0 - city2.0) as f64;
    let diffy = (city1.1 - city2.1) as f64;
    (diffx.powi(2) + diffy.powi(2)).sqrt()
}

// Function for total distance travelled
fn dist_cities(cities: &[CityID; NUM_CITIES]) -> f64 {
    let mut sum = 0.0;
    for i in 0..cities.len() - 1 {
        sum += dist_coords(cities[i].get_pos(), cities[i + 1].get_pos());
    }
    sum += dist_coords(cities[cities.len() - 1].get_pos(), cities[0].get_pos());
    sum
}

// 8 nearest cities, id cannot be at the border and has to have 8 valid neighbors
fn get_nearest(id: CityID) -> [CityID; 8] {
    let ij = id.get_pos();
    let i = ij.0;
    let j = ij.1;
    [
        CityID::from_coord((i - 1, j - 1)).unwrap(),
        CityID::from_coord((i, j - 1)).unwrap(),
        CityID::from_coord((i + 1, j - 1)).unwrap(),
        CityID::from_coord((i - 1, j)).unwrap(),
        CityID::from_coord((i + 1, j)).unwrap(),
        CityID::from_coord((i - 1, j + 1)).unwrap(),
        CityID::from_coord((i, j + 1)).unwrap(),
        CityID::from_coord((i + 1, j + 1)).unwrap(),
    ]
}

// Function for formatting of results
fn get_num_digits(mut num: i32) -> usize {
    let mut digits = 1;
    while num >= 10 {
        num /= 10;
        digits += 1;
    }
    digits
}

// Function for shuffling of initial state
fn shuffle_cities(cities: &mut [CityID], rng: &mut StdRng) {
    for i in (1..cities.len()).rev() {
        let j = rng.gen_range(0..=i);
        cities.swap(i, j);
    }
}

struct SA {
    k_t: i32,
    k_max: i32,
    s: [CityID; NUM_CITIES],
    rand_engine: StdRng,
}

impl SA {
    fn new() -> Self {
        let mut s = [CityID::new(); NUM_CITIES];

        // Initialize state with integers from 0 to 99
        for (i, city) in s.iter_mut().enumerate() {
            *city = CityID::from_int(i as i32);
        }

        let mut rand_engine = StdRng::seed_from_u64(0);
        shuffle_cities(&mut s, &mut rand_engine);

        SA {
            k_t: 1,
            k_max: 1_000_000,
            s,
            rand_engine,
        }
    }

    // Temperature
    fn temperature(&self, k: i32) -> f64 {
        self.k_t as f64 * (1.0 - k as f64 / self.k_max as f64)
    }

    // Probability of acceptance between 0.0 and 1.0
    fn probability(&self, d_e: f64, t: f64) -> f64 {
        if d_e < 0.0 {
            1.0
        } else {
            (-d_e / t).exp()
        }
    }

    // Permutation of state through swapping of cities in travel path
    fn next_permut(&mut self, mut cities: [CityID; NUM_CITIES]) -> [CityID; NUM_CITIES] {
        let disx = Uniform::new_inclusive(1, 8);
        let disy = Uniform::new_inclusive(1, 8);

        let rand_city = CityID::from_coord((
            disx.sample(&mut self.rand_engine),
            disy.sample(&mut self.rand_engine),
        )).unwrap();

        let neighbors = get_nearest(rand_city);
        let selector = Uniform::new(0, neighbors.len());
        let rand_neighbor = neighbors[selector.sample(&mut self.rand_engine)];

        // Find selected city in state
        let city_pos1 = cities.iter().position(|&x| x == rand_city).unwrap();
        let city_pos2 = cities.iter().position(|&x| x == rand_neighbor).unwrap();

        // Swap city and neighbor
        cities.swap(city_pos1, city_pos2);
        cities
    }

    // Logging function for progress output
    fn log_progress(&self, k: i32, t: f64, e: f64) {
        let nk = get_num_digits(self.k_max);
        let nt = get_num_digits(self.k_t);
        println!("k: {:width_k$} | T: {:width_t$.3} | E(s): {:.4}",
                 k, t, e, width_k = nk, width_t = nt);
    }

    // Logging function for final path
    fn log_path(&self) {
        for (idx, city) in self.s.iter().enumerate() {
            print!("{:2} -> ", city.v);
            if (idx + 1) % 20 == 0 {
                println!();
            }
        }
        println!("{:2}", self.s[0].v);
    }

    // Core simulated annealing algorithm
    fn run(&mut self) -> [CityID; NUM_CITIES] {
        println!("kT == {}", self.k_t);
        println!("kmax == {}", self.k_max);
        println!("E(s0) == {}", dist_cities(&self.s));

        for k in 0..self.k_max {
            let t = self.temperature(k);
            let e1 = dist_cities(&self.s);
            let s_next = self.next_permut(self.s);
            let e2 = dist_cities(&s_next);
            let d_e = e2 - e1; // lower is better

            let uniform_dist = Uniform::new(0.0, 1.0);
            let e = e1;

            if self.probability(d_e, t) >= uniform_dist.sample(&mut self.rand_engine) {
                self.s = s_next;
                // e = e2; // This variable is not used after assignment
            }

            if k % 100000 == 0 {
                self.log_progress(k, t, e1);
            }
        }

        self.log_progress(self.k_max, 0.0, dist_cities(&self.s));
        println!("\nFinal path:");
        self.log_path();
        self.s
    }
}

fn main() {
    let mut sa = SA::new();
    let _result = sa.run(); // Run simulated annealing and log progress and result

    println!("Press Enter to exit...");
    let mut input = String::new();
    std::io::stdin().read_line(&mut input).unwrap();
}

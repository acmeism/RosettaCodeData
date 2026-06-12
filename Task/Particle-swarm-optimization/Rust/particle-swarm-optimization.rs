use std::f64::consts::PI;
use rand::prelude::*;

const EPSILON: f64 = 0.001;

fn double_equals(a: f64, b: f64) -> bool {
    (a - b).abs() < EPSILON
}

fn vector_equals_f64(lhs: &[f64], rhs: &[f64]) -> bool {
    lhs.len() == rhs.len() && lhs.iter().zip(rhs).all(|(a, b)| double_equals(*a, *b))
}

fn vector_equals_2d(lhs: &[Vec<f64>], rhs: &[Vec<f64>]) -> bool {
    lhs.len() == rhs.len() && lhs.iter().zip(rhs).all(|(a, b)| vector_equals_f64(a, b))
}

#[derive(Debug, Clone)]
struct Parameters {
    omega: f64,
    phip: f64,
    phig: f64,
}

impl PartialEq for Parameters {
    fn eq(&self, other: &Self) -> bool {
        double_equals(self.omega, other.omega)
            && double_equals(self.phip, other.phip)
            && double_equals(self.phig, other.phig)
    }
}

#[derive(Debug, Clone)]
struct State {
    iter: i32,
    gbpos: Vec<f64>,
    gbval: f64,
    min: Vec<f64>,
    max: Vec<f64>,
    parameters: Parameters,
    pos: Vec<Vec<f64>>,
    vel: Vec<Vec<f64>>,
    bpos: Vec<Vec<f64>>,
    bval: Vec<f64>,
    n_particles: usize,
    n_dims: usize,
}

impl PartialEq for State {
    fn eq(&self, other: &Self) -> bool {
        self.iter == other.iter
            && vector_equals_f64(&self.gbpos, &other.gbpos)
            && double_equals(self.gbval, other.gbval)
            && vector_equals_f64(&self.min, &other.min)
            && vector_equals_f64(&self.max, &other.max)
            && self.parameters == other.parameters
            && vector_equals_2d(&self.pos, &other.pos)
            && vector_equals_2d(&self.vel, &other.vel)
            && vector_equals_2d(&self.bpos, &other.bpos)
            && vector_equals_f64(&self.bval, &other.bval)
            && self.n_particles == other.n_particles
            && self.n_dims == other.n_dims
    }
}

impl State {
    fn report(&self, test_func: &str) {
        println!("Test Function        : {}", test_func);
        println!("Iterations           : {}", self.iter);
        println!("Global Best Position : {:?}", self.gbpos);
        println!("Global Best Value    : {}", self.gbval);
    }
}

fn pso_init(min: Vec<f64>, max: Vec<f64>, parameters: Parameters, n_particles: usize) -> State {
    let n_dims = min.len();

    let pos = vec![min.clone(); n_particles];
    let vel = vec![vec![0.0; n_dims]; n_particles];
    let bpos = vec![min.clone(); n_particles];
    let bval = vec![f64::INFINITY; n_particles];

    let iter = 0;
    let gbpos = vec![f64::INFINITY; n_dims];
    let gbval = f64::INFINITY;

    State {
        iter,
        gbpos,
        gbval,
        min,
        max,
        parameters,
        pos,
        vel,
        bpos,
        bval,
        n_particles,
        n_dims,
    }
}

fn pso<F>(func: F, state: &State) -> State
where
    F: Fn(&[f64]) -> f64,
{
    let mut rng = rand::rng();
    let p = &state.parameters;

    let mut v = vec![0.0; state.n_particles];
    let mut bpos = vec![state.min.clone(); state.n_particles];
    let mut bval = vec![0.0; state.n_particles];
    let mut gbpos = vec![0.0; state.n_dims];
    let mut gbval = f64::INFINITY;

    // Evaluate and update best positions
    for j in 0..state.n_particles {
        v[j] = func(&state.pos[j]);

        if v[j] < state.bval[j] {
            bpos[j] = state.pos[j].clone();
            bval[j] = v[j];
        } else {
            bpos[j] = state.bpos[j].clone();
            bval[j] = state.bval[j];
        }

        if bval[j] < gbval {
            gbval = bval[j];
            gbpos = bpos[j].clone();
        }
    }

    let rg = rng.random::<f64>();

    let mut pos = vec![vec![0.0; state.n_dims]; state.n_particles];
    let mut vel = vec![vec![0.0; state.n_dims]; state.n_particles];

    // Update particle positions and velocities
    for j in 0..state.n_particles {
        let rp = rng.random::<f64>();
        let mut ok = true;

        for k in 0..state.n_dims {
            vel[j][k] = p.omega * state.vel[j][k]
                + p.phip * rp * (bpos[j][k] - state.pos[j][k])
                + p.phig * rg * (gbpos[k] - state.pos[j][k]);

            pos[j][k] = state.pos[j][k] + vel[j][k];

            ok = ok && state.min[k] < pos[j][k] && state.max[k] > pos[j][k];
        }

        if !ok {
            for k in 0..state.n_dims {
                pos[j][k] = state.min[k] + (state.max[k] - state.min[k]) * rng.random::<f64>();
            }
        }
    }

    let iter = state.iter + 1;

    State {
        iter,
        gbpos,
        gbval,
        min: state.min.clone(),
        max: state.max.clone(),
        parameters: state.parameters.clone(),
        pos,
        vel,
        bpos,
        bval,
        n_particles: state.n_particles,
        n_dims: state.n_dims,
    }
}

fn iterate<F>(func: F, n: Option<i32>, state: &State) -> State
where
    F: Fn(&[f64]) -> f64,
{
    let mut result = state.clone();

    match n {
        None => {
            // Iterate until convergence
            loop {
                let old = result.clone();
                result = pso(&func, &result);
                if result == old {
                    break;
                }
            }
        }
        Some(iterations) => {
            for _ in 0..iterations {
                result = pso(&func, &result);
            }
        }
    }

    result
}

fn mccormick(x: &[f64]) -> f64 {
    let a = x[0];
    let b = x[1];
    (a + b).sin() + (a - b).powi(2) + 1.0 + 2.5 * b - 1.5 * a
}

fn michalewicz(x: &[f64]) -> f64 {
    let m = 10;
    let d = x.len();
    let mut sum = 0.0;

    for i in 1..d {
        let j = x[i - 1];
        let k = ((i as f64) * j * j / PI).sin();
        sum += j.sin() * k.powf(2.0 * m as f64);
    }

    -sum
}

fn main() {
    // Test McCormick function
    let mut state = pso_init(
        vec![-1.5, -3.0],
        vec![4.0, 4.0],
        Parameters {
            omega: 0.0,
            phip: 0.6,
            phig: 0.3,
        },
        100,
    );

    state = iterate(mccormick, Some(40), &state);
    state.report("McCormick");
    println!("f(-0.54719, -1.54719) : {}", mccormick(&[-0.54719, -1.54719]));
    println!();

    // Test Michalewicz function
    state = pso_init(
        vec![0.0, 0.0],
        vec![PI, PI],
        Parameters {
            omega: 0.3,
            phip: 0.3,
            phig: 0.3,
        },
        1000,
    );

    state = iterate(michalewicz, Some(30), &state);
    state.report("Michalewicz (2D)");
    println!("f(2.20, 1.57)        : {}", michalewicz(&[2.2, 1.57]));
}

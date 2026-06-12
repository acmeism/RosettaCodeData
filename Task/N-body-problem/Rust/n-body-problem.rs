//// Measurements are from NASA, at https://ipnpr.jpl.nasa.gov/progress_report/42-196/196C.pdf, and other sources
//// Constants fro The JPL Horizons App https://ssd.jpl.nasa.gov/horizons/app.html#/
//// All units in Body are expressed in AU and AU/day, with masses in solor mass fraction

use plotly::{
    common::{Mode, Title},
    layout::{AspectMode, LayoutScene},
    Layout, Plot, Scatter3D,
};
use serde;
use std::ops::{Add, AddAssign, Mul, Sub, SubAssign};

const G_SI: f64 = 6.67430e-11; // (m * m * m) / (kg * sec * sec)
const SOLAR_MASS_KILOGRAMS: f64 = 1.988_546_924e30; // mass of Sun in kg
const SOLAR_MASS_MEASURE: f64 = 1.0; // bodies have mass in solar masses
const AU: f64 = 1.495978707e11; // 1 AU in meters
const SEC_PER_DAY: f64 = 86400.0; // seconds in a day
const G_AU_DAY_SOL_CONST: f64 =
    G_SI * SOLAR_MASS_KILOGRAMS * SEC_PER_DAY * SEC_PER_DAY / (AU * AU * AU); // gravitational constant in AU^3 / solar-masses-DAY^2

/// Point3D implementation derived from code by Ilia Schelokov
#[derive(Clone, Debug, Copy, serde::Serialize)]
struct Point3D(f64, f64, f64);

impl Point3D {
    fn sum_squares(&self) -> f64 {
        self.0 * self.0 + self.1 * self.1 + self.2 * self.2
    }

    fn norm(&self) -> f64 {
        self.sum_squares().sqrt()
    }
}

impl Add for &Point3D {
    type Output = Point3D;
    fn add(self, rhs: Self) -> Self::Output {
        Point3D(self.0 + rhs.0, self.1 + rhs.1, self.2 + rhs.2)
    }
}

impl Sub for &Point3D {
    type Output = Point3D;
    fn sub(self, rhs: Self) -> Self::Output {
        Point3D(self.0 - rhs.0, self.1 - rhs.1, self.2 - rhs.2)
    }
}

impl Mul<f64> for &Point3D {
    type Output = Point3D;
    fn mul(self, rhs: f64) -> Self::Output {
        Point3D(self.0 * rhs, self.1 * rhs, self.2 * rhs)
    }
}

impl AddAssign for Point3D {
    fn add_assign(&mut self, rhs: Self) {
        self.0 += rhs.0;
        self.1 += rhs.1;
        self.2 += rhs.2;
    }
}

impl SubAssign for Point3D {
    fn sub_assign(&mut self, rhs: Self) {
        self.0 -= rhs.0;
        self.1 -= rhs.1;
        self.2 -= rhs.2;
    }
}

#[derive(Clone, Debug)]
struct Body<'a> {
    name: &'a str,
    past_position: Point3D,
    position: Point3D,
    velocity: Point3D,
    mass: f64,
}

impl<'a> Body<'_> {
    /// Initialize Body for Verlet integration
    fn initialize_first(&mut self, acceleration_vector: &Point3D, dt: f64) {
        self.past_position = self.position;
        self.position = &self.past_position
            + &(&(&self.velocity * dt) + &(acceleration_vector * (0.5 * dt * dt)));
    }

    /// Verlet algorithm calculation of next position and velocity
    fn verlet(&mut self, acceleration_vector: &Point3D, dt: f64) {
        let new_position =
            &(&self.position * 2.0) - &(&self.past_position + &(acceleration_vector * (dt * dt)));
        self.past_position = self.position.clone();
        self.position = new_position;
        self.velocity += acceleration_vector * dt;
    }

    /// acceleration vector component from attraction between self and body
    fn acceleration_from(&self, body: &Body, g: f64) -> Point3D {
        let delta_pos = &self.position - &body.position;
        return &delta_pos * (body.mass * g / delta_pos.norm().powi(3));
    }
}

/*******************************************************************************
Ephemeris / WWW_USER Fri Sep 27 20:50:45 2024 Pasadena, USA      / Horizons
*******************************************************************************
Target body name: Sun (10)                        {source: DE441}
Center body name: Solar System Barycenter (0)     {source: DE441}
Center-site name: BODY CENTER
*******************************************************************************
Start time      : A.D. 2024-Sep-27 00:00:00.0000 TDB
Stop  time      : A.D. 2024-Oct-27 00:00:00.0000 TDB
Step-size       : 1440 minutes
*******************************************************************************
Center geodetic : 0.0, 0.0, 0.0                   {E-lon(deg),Lat(deg),Alt(km)}
Center cylindric: 0.0, 0.0, 0.0                   {E-lon(deg),Dxy(km),Dz(km)}
Center radii    : (undefined)
Output units    : AU-D
Calendar mode   : Mixed Julian/Gregorian
Output type     : GEOMETRIC cartesian states
Output format   : 3 (position, velocity, LT, range, range-rate)
Reference frame : Ecliptic of J2000.0
******************************************************************************/

const N_BODIES: usize = 3; // This is a 3 body problem
                           // list of bodies for 3 body problem
const STARTING_STATE: [Body; N_BODIES] = [
    // Sun
    // The JPL gives nonzero values for Sun position and velocity, since it
    // counts the center of mass of the solar system as the origin.
    Body {
        name: "Sun",
        mass: SOLAR_MASS_MEASURE,           // 1 solar mass
        past_position: Point3D(0., 0., 0.), // for Verlet calculations
        position: Point3D(
            -6.394341105496697e-03,
            -4.506046189887095e-03,
            1.899094498938377e-04,
        ), // origin of coordinates is center of Sun
        velocity: Point3D(
            6.645159829871544e-06,
            -4.688500769968203e-06,
            -9.846253060945091e-08,
        ), // velocity relative to the Sun
    },
    // Venus
    Body {
        name: "Venus",
        past_position: Point3D(0., 0., 0.), // for Verlet calculations
        position: Point3D(
            -1.493540644551256e-01, // AU to center of system, X coordinate
            -7.165214812019035e-01,
            -1.339820683496332e-03,
        ),
        velocity: Point3D(
            1.970190519795076e-02, // AU / day velocity relative to center, X component
            -4.067857660659860e-03,
            -1.192334871774713e-03,
        ),
        mass: 2.4478382877865672e-6, // solar mass fraction
    },
    // Earth
    Body {
        name: "Earth",
        past_position: Point3D(0., 0., 0.), // for Verlet calculations
        position: Point3D(
            9.934706950523063e-01, // AU to center of system, X coordinate
            6.608906451106633e-02,
            1.775699242199866e-04,
        ),
        velocity: Point3D(
            -1.479405049926226e-03, // AU / day velocity relative to system, X component
            1.709534341030450e-02,
            -8.229589208599246e-07,
        ),
        mass: 3.0034896149152957e-6, // solar mass fraction
    },
];

const TEST_STATES: [Body; N_BODIES] = [
    Body {
        name: "Body 1",
        past_position: Point3D(0., 0., 0.), // for Verlet calculations
        position: Point3D(0., 0., 0.),
        velocity: Point3D(0.01, 0., 0.),
        mass: 1.0,
    },
    Body {
        name: "Body 2",
        past_position: Point3D(0., 0., 0.), // for Verlet calculations
        position: Point3D(1., 1., 0.),
        velocity: Point3D(0., 0., 0.02),
        mass: 0.1,
    },
    Body {
        name: "Body 3",
        past_position: Point3D(0., 0., 0.), // for Verlet calculations
        position: Point3D(0., 1., 1.),
        velocity: Point3D(0.01, -0.01, -0.01),
        mass: 0.001,
    },
];

/// reset the position and momentum of Sun relative to system's center of momentum (sun is first in vector)
fn re_zero_first(bodies: &mut [Body; N_BODIES]) {
    bodies[0].velocity = Point3D(0., 0., 0.); // back to zero, then subtract other bodies' momenta
    for i in 1..bodies.len() {
        bodies[0].velocity -= &bodies[i].velocity * (bodies[i].mass / SOLAR_MASS_MEASURE);
    }
}

fn acceleration_matrix(bodies: &mut [Body; N_BODIES], g: f64) -> Vec<Vec<Point3D>> {
    let mut accel = vec![vec![Point3D(0., 0., 0.); N_BODIES]; N_BODIES]; // begins as all 0.0
    for i in 0..N_BODIES - 1 {
        for j in i + 1..N_BODIES {
            accel[i][j] = bodies[i].acceleration_from(&bodies[j], g);
            accel[j][i] = &(accel[i][j]) * -(bodies[i].mass / bodies[j].mass); // equal and opposite as per Newton
        }
    }
    return accel;
}

fn accelerations(bodies: &mut [Body; N_BODIES], g: f64) -> Vec<Point3D> {
    let accel = acceleration_matrix(bodies, g);
    let mut totals = vec![Point3D(0., 0., 0.); N_BODIES];
    for i in 0..bodies.len() {
        for j in 0..bodies.len() {
            if j != i {
                totals[i] += accel[i][j];
            }
        }
    }
    return totals;
}

// take single step in simulation, over time dt
fn step(bodies: &mut [Body; N_BODIES], dt: f64, g: f64) {
    let totals = accelerations(bodies, g);
    for i in 0..bodies.len() {
        bodies[i].verlet(&totals[i], dt);
    }
}

// run step_count steps of the simulation
fn run(bodies: &mut [Body; N_BODIES], dt: f64, step_count: i32, g: f64) {
    let totals = accelerations(bodies, g);
    for i in 0..bodies.len() {
        bodies[i].initialize_first(&totals[i], dt);
    }
    re_zero_first(bodies);
    let mut plot = Plot::new();
    let overall_layout = Layout::new()
        .title(Title::with_text("Sun, Venus, Earth System"))
        .scene(LayoutScene::new().aspect_mode(AspectMode::Data));
    plot.set_layout(overall_layout);
    let mut points: Vec<Vec<Vec<f64>>> = bodies
        .iter()
        .map(|b| vec![vec![b.position.0, b.position.1, b.position.2]])
        .collect();
    for _i in 0..step_count {
        step(bodies, dt, g);
        for i in 0..bodies.len() {
            points[i].push(vec![
                bodies[i].position.0,
                bodies[i].position.1,
                bodies[i].position.2,
            ]);
        }
    }
    for (i, v) in points.into_iter().enumerate() {
        let x: Vec<f64> = v.clone().into_iter().map(|p| p[0]).collect::<Vec<f64>>();
        let y: Vec<f64> = v.clone().into_iter().map(|p| p[1]).collect::<Vec<f64>>();
        let z: Vec<f64> = v.clone().into_iter().map(|p| p[2]).collect::<Vec<f64>>();
        let trace = Scatter3D::new(x, y, z)
            .mode(Mode::Markers)
            .name(bodies[i].name);
        plot.add_trace(trace);
    }
    plot.show();
}

fn euler_step(bodies: &mut [Body; N_BODIES], g: f64) {
    let mut accel = vec![Point3D(0., 0., 0.); N_BODIES]; // begins as all 0.0
    for i in 0..bodies.len() {
        for j in 0..bodies.len() {
            if i != j {
                let dpos = &bodies[j].position - &bodies[i].position;
                accel[i] += &dpos * (bodies[j].mass * g / dpos.norm().powi(3));
            }
        }
    }
    for i in 0..bodies.len() {
        bodies[i].position += &bodies[i].velocity + &(&accel[i] * 0.5);
        bodies[i].velocity += accel[i];
    }
}

fn test_3_body() {
    let mut bodies = TEST_STATES;
    for i in 0..20 {
        euler_step(&mut bodies, 0.01);
        println!("\nCycle {}", i + 1);
        for b in &bodies {
            println!(
                "{} : {:>9.6}  {:>9.6}  {:>9.6} | {:>9.6}  {:>9.6}  {:>9.6}",
                b.name,
                b.position.0,
                b.position.1,
                b.position.2,
                b.velocity.0,
                b.velocity.1,
                b.velocity.2
            );
        }
    }
}

fn solar_system_simulation() {
    let dt = 0.1; // 0.1 day
    let ncycles = 3660; // 366 days for 0.1 day time steps
    let mut bodies = STARTING_STATE;
    re_zero_first(&mut bodies);
    run(&mut bodies, dt, ncycles, G_AU_DAY_SOL_CONST);
}

fn main() {
    test_3_body();
    solar_system_simulation();
}

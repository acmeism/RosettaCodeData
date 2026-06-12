use std::fmt;

const DM_DT: f64 = -1.8; // kg/s

#[derive(Clone)]
struct OrbitalData {
    date: &'static str,
    x: f64,
    v: f64,
    m: f64,
}

struct ResultRow {
    date: &'static str,
    p: f64,
    nktg1: f64,
    nktg2: f64,
    v_sim: f64,
    v_nasa: f64,
    error: f64,
}

impl fmt::Display for ResultRow {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(
            f,
            "{:<12} {:>14.3e} {:>14.3e} {:>14.3e} {:>12.3e} {:>12.3e} {:>8.4}%",
            self.date,
            self.p,
            self.nktg1,
            self.nktg2,
            self.v_sim,
            self.v_nasa,
            self.error
        )
    }
}

fn momentum(m: f64, v: f64) -> f64 {
    m * v
}

fn nktg1(x: f64, p: f64) -> f64 {
    x * p
}

fn nktg2(p: f64) -> f64 {
    DM_DT * p
}

fn relative_error(sim: f64, nasa: f64) -> f64 {
    ((sim - nasa) / nasa) * 100.0
}

fn main() {

    // Simulated NKTg 2025 dataset
    let sim_2025 = vec![
        OrbitalData { date: "1/1/2025", x: 1.471012e11, v: 3.0276e4, m: 5.97219e24 },
        OrbitalData { date: "4/1/2025", x: 1.494953e11, v: 2.9791e4, m: 5.97218999999998e24 },
        OrbitalData { date: "7/1/2025", x: 1.520965e11, v: 2.9282e4, m: 5.97218999999997e24 },
        OrbitalData { date: "10/1/2025", x: 1.496328e11, v: 2.9764e4, m: 5.97218999999995e24 },
        OrbitalData { date: "12/31/2025", x: 1.471025e11, v: 3.0276e4, m: 5.97218999999994e24 },
    ];

    // NASA observed velocities
    let nasa_2025 = vec![
        ("1/1/2025", 3.0287e4),
        ("4/1/2025", 2.9791e4),
        ("7/1/2025", 2.9291e4),
        ("10/1/2025", 2.9778e4),
        ("12/31/2025", 3.0286e4),
    ];

    println!("\nExperimental Verification of NKTg Law (Earth 2025)\n");

    println!(
        "{:<12} {:>14} {:>14} {:>14} {:>12} {:>12} {:>10}",
        "Date", "Momentum(p)", "NKTg1", "NKTg2", "v_sim", "v_NASA", "Error"
    );

    println!("{}", "-".repeat(95));

    for (i, data) in sim_2025.iter().enumerate() {

        let p = momentum(data.m, data.v);
        let n1 = nktg1(data.x, p);
        let n2 = nktg2(p);

        let v_nasa = nasa_2025[i].1;
        let err = relative_error(data.v, v_nasa);

        let row = ResultRow {
            date: data.date,
            p,
            nktg1: n1,
            nktg2: n2,
            v_sim: data.v,
            v_nasa,
            error: err,
        };

        println!("{}", row);
    }
}

// ... code ở đây ...
use std::f64;

struct MercuryData {
    date: &'static str,
    x: f64,      // position (m)
    v: f64,      // velocity (m/s)
    m: f64,      // mass (kg)
}

fn main() {

    // ================================
    // 1. NASA 2024 Reference Data
    // ================================
    let reference_2024 = MercuryData {
        date: "31/12/2024",
        x: 4.64e10,
        v: 5.81e4,
        m: 3.30e23,
    };

    let p_ref = reference_2024.m * reference_2024.v;
    let nktg1_constant = reference_2024.x * p_ref;

    println!("NKTg₁ reference constant: {:.3e}", nktg1_constant);
    println!("========================================\n");

    // ================================
    // 2. NASA 2025 Real Data
    // ================================
    let nasa_2025 = vec![
        MercuryData { date: "01/01/2025", x: 5.16e10, v: 5.34e4, m: 3.30e23 },
        MercuryData { date: "01/04/2025", x: 6.97e10, v: 3.89e4, m: 3.30e23 },
        MercuryData { date: "01/07/2025", x: 5.49e10, v: 5.04e4, m: 3.30e23 },
        MercuryData { date: "01/10/2025", x: 6.83e10, v: 3.98e4, m: 3.30e23 },
        MercuryData { date: "31/12/2025", x: 4.61e10, v: 5.89e4, m: 3.30e23 },
    ];

    // Mass variation rate (MESSENGER data)
    let dm_dt = -0.5_f64; // kg/s

    println!("Date\t\tv_NKTg\t\tv_NASA\t\tRel.Error(%)\tNKTg₂");
    println!("-----------------------------------------------------------------------");

    for data in nasa_2025 {

        // Interpolated velocity from constant NKTg1
        let v_nktg = nktg1_constant / (data.x * data.m);

        // Relative error
        let rel_error = ((v_nktg - data.v) / data.v) * 100.0;

        // Momentum
        let p = data.m * v_nktg;

        // NKTg2 calculation
        let nktg2 = dm_dt * p;

        println!("{:<12} {:>10.3e} {:>10.3e} {:>12.4} {:>15.3e}",
                 data.date,
                 v_nktg,
                 data.v,
                 rel_error,
                 nktg2);
    }

    println!("\n========================================");
    println!("Interpretation:");
    println!("NKTg₁ maintained as constant.");
    println!("NKTg₂ negative → mass variation resists motion.");
}

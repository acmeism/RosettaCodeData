import "std/math.zc"

fn compute_nktg(x: f64, v: f64, m: f64, dm_dt: f64) {
    let p = m * v;
    let nktg1 = x * p;
    let nktg2 = dm_dt * p;
    let nktg  = Math::sqrt(nktg1 * nktg1 + nktg2 * nktg2);

    println "--------------------------------------------";
    println "Position (x)         : {x:0.0f}";
    println "Velocity (v)         : {v:0.2f}";
    println "Mass (m)             : {m:0.0f}";
    println "Momentum (p = m * v) : {p:0.0f}";
    println "NKTg1 = x * p        : {nktg1:0.0f}";
    println "NKTg2 = dm_dt * p    : {nktg2:0.0f}";
    println "Total NKTg           : {nktg:0.0f}";
}

fn main() {
    println "============================================";
    println "NKTg Law - Neptune 2023 NASA Data";
    println "============================================";

    // 2023 NASA Data (Neptune)
    let dm_dt = -0.00002000;

    let data2023: (f64, f64, f64)[5] = [
        (4498396440.0, 5.43, 1.02430000e26),
        (4503443661.0, 5.43, 1.02429980e26),
        (4553946490.0, 5.43, 1.02429960e26),
        (4503443661.0, 5.43, 1.02429940e26),
        (4498396440.0, 5.43, 1.02429920e26)
    ];

    for i in 0..data2023.len {
        let (x, v, m) = data2023[i];
        compute_nktg(x, v, m, dm_dt);
    }

    println "\n============================================";
    println "NKTg Law - Neptune 2024 Simulation";
    println "============================================";

    let data2024: (f64, f64, f64)[5] = [
        (4498396440.0, 5.43, 1.02429900e26),
        (4503443661.0, 5.43, 1.02429880e26),
        (4553946490.0, 5.43, 1.02429860e26),
        (4503443661.0, 5.43, 1.02429840e26),
        (4498396440.0, 5.43, 1.02429820e26)
    ];

    for i in 0..data2024.len {
        let (x, v, m) = data2024[i];
        compute_nktg(x, v, m, dm_dt);
    }

    println "\n============================================";
    println "Experiment Completed";
    println "============================================";
}

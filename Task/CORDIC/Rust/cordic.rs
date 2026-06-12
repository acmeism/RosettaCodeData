use std::f64::consts::PI;

// Constants for angles and kvalues
const ANGLES: [f64; 28] = [
    0.78539816339745, 0.46364760900081, 0.24497866312686, 0.12435499454676,
    0.06241880999596, 0.03123983343027, 0.01562372862048, 0.00781234106010,
    0.00390623013197, 0.00195312251648, 0.00097656218956, 0.00048828121119,
    0.00024414062015, 0.00012207031189, 0.00006103515617, 0.00003051757812,
    0.00001525878906, 0.00000762939453, 0.00000381469727, 0.00000190734863,
    0.00000095367432, 0.00000047683716, 0.00000023841858, 0.00000011920929,
    0.00000005960464, 0.00000002980232, 0.00000001490116, 0.00000000745058,
];

const KVALUES: [f64; 24] = [
    0.70710678118655, 0.63245553203368, 0.61357199107790, 0.60883391251775,
    0.60764825625617, 0.60735177014130, 0.60727764409353, 0.60725911229889,
    0.60725447933256, 0.60725332108988, 0.60725303152913, 0.60725295913894,
    0.60725294104140, 0.60725293651701, 0.60725293538591, 0.60725293510314,
    0.60725293503245, 0.60725293501477, 0.60725293501035, 0.60725293500925,
    0.60725293500897, 0.60725293500890, 0.60725293500889, 0.60725293500888,
];

// Function to convert degrees to radians
fn radians(degrees: f64) -> f64 {
    degrees * PI / 180.0
}

// Cordic algorithm implementation
fn cordic(alpha: f64, n: usize, c_cos: &mut f64, c_sin: &mut f64) {
    let mut theta = 0.0;
    let mut pow2 = 1.0;
    let mut x = 1.0;
    let mut y = 0.0;
    let newsgn = if (alpha / (2.0 * PI)).floor() as i32 % 2 == 1 { 1.0 } else { -1.0 };

    if alpha < -PI / 2.0 || alpha > PI / 2.0 {
        if alpha < 0.0 {
            cordic(alpha + PI, n, &mut x, &mut y);
        } else {
            cordic(alpha - PI, n, &mut x, &mut y);
        }
        *c_cos = x * newsgn;
        *c_sin = y * newsgn;
        return;
    }

    let ix = if n - 1 > 23 { 23 } else { n - 1 };
    let kn = KVALUES[ix];

    for i in 0..n {
        let atn = ANGLES[i];
        let sigma = if theta < alpha { 1.0 } else { -1.0 };
        theta += sigma * atn;
        let t = x;
        x -= sigma * y * pow2;
        y += sigma * t * pow2;
        pow2 /= 2.0;
    }

    *c_cos = x * kn;
    *c_sin = y * kn;
}

fn main() {
    let mut c_cos: f64;
    let mut c_sin: f64;
    let test_angles = [-9.0, 0.0, 1.5, 6.0];

    println!("  x       sin(x)     diff. sine     cos(x)    diff. cosine");
    for th in (-90..=90).step_by(15) {
        let thr = radians(th as f64);
        c_cos = 0.0;
        c_sin = 0.0;
        cordic(thr, 24, &mut c_cos, &mut c_sin);
        println!("{:+03}.0°  {:+.8} ({:+.8}) {:+.8} ({:+.8})", th, c_sin, c_sin - thr.sin(), c_cos, c_cos - thr.cos());
    }

    println!("\nx(rads)   sin(x)     diff. sine     cos(x)    diff. cosine");
    for &angle in &test_angles {
        let thr = angle;
        c_cos = 0.0;
        c_sin = 0.0;
        cordic(thr, 24, &mut c_cos, &mut c_sin);
        println!("{:+4.1}    {:+.8} ({:+.8}) {:+.8} ({:+.8})", thr, c_sin, c_sin - thr.sin(), c_cos, c_cos - thr.cos());
    }
}

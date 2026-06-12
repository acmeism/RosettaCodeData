const RE: f64 = 6371000.0; // Earth radius in meters
const DD: f64 = 0.001; // integrate in this fraction of the distance already covered
const FIN: f64 = 10000000.0; // integrate only to a height of 10000km, effectively infinity

fn rho(a: f64) -> f64 {
    // the density of air as a function of height above sea level
    (-a / 8500.0).exp()
}

fn height(a: f64, z: f64, d: f64) -> f64 {
    // a = altitude of observer
    // z = zenith angle (in degrees)
    // d = distance along line of sight
    let aa = RE + a;
    let hh = (aa * aa + d * d - 2.0 * d * aa * (180.0 - z).to_radians().cos()).sqrt();
    hh - RE
}

fn column_density(a: f64, z: f64) -> f64 {
    // integrates density along the line of sight
    let mut sum = 0.0;
    let mut d = 0.0;
    while d < FIN {
        // adaptive step size to avoid it taking forever
        let mut delta = DD * d;
        if delta < DD {
            delta = DD;
        }
        sum += rho(height(a, z, d + 0.5 * delta)) * delta;
        d += delta;
    }
    sum
}

fn airmass(a: f64, z: f64) -> f64 {
    column_density(a, z) / column_density(a, 0.0)
}

fn main() {
    println!("Angle     0 m              13700 m");
    println!("------------------------------------");
    for a in (0..=90).step_by(5) {
        let z = a as f64;
        println!(
            "{:2}      {:11.8}      {:11.8}",
            z,
            airmass(0.0, z),
            airmass(13700.0, z)
        );
    }
}

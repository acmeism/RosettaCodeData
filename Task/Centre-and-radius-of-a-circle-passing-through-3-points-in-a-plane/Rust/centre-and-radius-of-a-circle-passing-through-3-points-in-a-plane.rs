use core::f64;
use num::complex::{Complex, ComplexFloat};

#[derive(PartialEq)] // relation derived on Point: two instances are equal if all fields are equal
struct Point {
    x: f64,
    y: f64,
}

struct Circle {
    center: Point,
    radius: f64
}

fn circle_through_3_points_2_d(p1: &Point, p2: &Point, p3: &Point) -> Result<Circle, String> {
    // following https://math.stackexchange.com/questions/213658/get-the-equation-of-a-circle-when-given-3-points
    // following https://web.archive.org/web/20060909065617/http://www.math.okstate.edu/~wrightd/INDRA/MobiusonCircles/node4.html

    // A. safety checks first

    // A.1 check for identity of two points
    if p1.eq(p2) || p2.eq(p3) || p3.eq(p1) {
        // these are not three distinct vertices of a triangle
        // assumptions are not met: refuse computation
        return Err("at least two of three points are identical".to_string())
    }

    // A.2 check for overflow: squares will be computed later, make sure this doesn't cause an overflow
    if is_unsafe_square(p1) || is_unsafe_square(p2) || is_unsafe_square(p3) {
        return Err("at least one coordinate.abs() > MAX.sqrt() or < MIN_POSITIVE.sqrt()".to_string());
    }

    // A.2.1 check for overflow: complex arithmetic will be done later, set a reasonably low threshold
    //       to prevent overflow or underflow
    fn is_unsafe_square(p: &Point) -> bool {
        p.x.abs() > f64::MAX.sqrt() || p.y.abs() > f64::MAX.sqrt() ||
        p.x.abs() < f64::MIN_POSITIVE.sqrt() || p.y.abs() < f64::MIN_POSITIVE.sqrt()
    }

    // B. Transform the problem to complex plane
    // interpret the three points (p1,p2,p3) as being (z1,z2,z3) in the complex plane.
    let (z1, z2, z3) = to_complex(p1, p2, p3);

    // B.1 transform zi -> zti such that
    // zt1 = 0, zt2 = 1, zt3 = to be computed
    let zt3: Complex<f64> = (z3 - z1) / (z2 - z1);

    // B.2 check for collinearity
    if zt3.im == 0.0 {
        return Err("three points are collinear".to_string())
    }

    // B.3 the transformed center of the circle is on the line re=0.5, all im except im=0.0.
    // Determine its specific position
    let ct: Complex<f64> = (zt3 - norm(&zt3)) / (zt3 - zt3.conj());
    let c: Complex<f64> = (z2-z1) * ct + z1;
    let r: f64 = modulus(&(z1-c));

    let c = Circle {
        center: Point {x: c.re, y: c.im},
        radius: r
    };
    return Ok(c)
}

fn to_complex(p1: &Point, p2: &Point, p3: &Point) -> (Complex<f64>, Complex<f64>, Complex<f64>) {
    let z1 = Complex::new(p1.x, p1.y);
    let z2 = Complex::new(p2.x, p2.y);
    let z3: Complex<f64> = Complex::new(p3.x, p3.y);
    (z1, z2, z3)
}

fn modulus(z: &Complex<f64>) -> f64 {
    // an implementation of (re^2 + im^2).sqrt() which prevents overflow and underflow
    // see Press et al.: Numerical Recipes in C++, 2002, p. 183
    if (z.re.abs()) >= (z.im.abs()) {
        z.re.abs() * (1.0 + (z.im / z.re).powf(2.0)).sqrt()
    } else {
        z.im.abs() * (1.0 + (z.re / z.im).powf(2.0)).sqrt()
    }
}

fn norm(z: &Complex<f64>) -> f64 {
    modulus(z).powf(2.0)
}


fn main() {
    let result = circle_through_3_points_2_d(
        &Point {x: 22.83, y: 2.07},
        &Point {x: 14.39, y: 30.24},
        &Point {x: 33.65, y: 17.31}
    );
    match result {
        Ok(circle) => {
            println!("circle.center.x={}", circle.center.x);
            println!("circle.center.y={}", circle.center.y);
            println!("circle.radius={}", circle.radius);
        }
        Err(e) => eprintln!("{}",e) // output goes to io::stderr instead of io::stdout
    }
}

#[cfg(test)]
mod tests {
    use super::*; // parent of current module
    use assert_float_eq::assert_f64_near;

    #[test]
    fn reference_triangle() {
        // this is the reference triangle specified at rosettacode.org
        let result = circle_through_3_points_2_d(
            &Point {x: 22.83, y: 2.07},
            &Point {x: 14.39, y: 30.24},
            &Point {x: 33.65, y: 17.31});
        match result {
            Ok(circle) => {
                // comparison of floats is difficult. crate assert_float_eq tries to address this
                assert_f64_near!(circle.center.x, 18.978515660148815);
            }
            Err(e) => {
                eprintln!("{}",e);
                panic!("reference_triangle")
            }
        }
    }

    #[test]
    fn two_identical_points() {
        // this is the reference triangle specified at rosettacode.org but p1==p3
        let result = circle_through_3_points_2_d(
            &Point {x: 22.83, y: 2.07},
            &Point {x: 14.39, y: 30.24},
            &Point {x: 22.83, y: 2.07});
        match result {
            Ok(circle) => {
                println!("{}",circle.center.x);
                panic!("two_identical_points: code claims there is a solution where a solution is not possible")
            }
            Err(e) => {
                // this is what we expect
                eprintln!("{}",e);
                // panic!("two_identical_points")
            }
        }
    }

    #[test]
    fn coordinate_gt_max_sqrt() {
        // p1x is greater than the square root of MAX w.r.t. f64
        let result = circle_through_3_points_2_d(
            &Point {x: 22.83E+300f64,   y: 2.07},
            &Point {x: 14.39,           y: 30.24},
            &Point {x: 33.65,           y: 17.31});
        match result {
            Ok(circle) => {
                println!("{}",circle.center.x);
                panic!("coordinate_gt_max_sqrt: code failed to detect potential overflow")
            }
            Err(e) => {
                // this is what we expect
                eprintln!("{}",e);
                // panic!("coordinate_gt_max_sqrt")
            }
        }
    }

    #[test]
    fn coordinate_lt_min_sqrt() {
        // p1x is lower than the square root of MIN w.r.t. f64
        let result = circle_through_3_points_2_d(
            &Point {x: 22.83E-300f64,   y: 2.07},
            &Point {x: 14.39,           y: 30.24},
            &Point {x: 33.65,           y: 17.31});
        match result {
            Ok(circle) => {
                println!("{}",circle.center.x);
                panic!("coordinate_lt_min_sqrt: code failed to detect potential underflow")
            }
            Err(e) => {
                // this is what we expect
                eprintln!("{}",e);
                // panic!("coordinate_lt_min_sqrt")
            }
        }
    }

     #[test]
    fn collinearity() {
        // p1, p2, p3 are collinear
        let result = circle_through_3_points_2_d(
            &Point {x: 1.0, y: 1.0},
            &Point {x: 2.0, y: 4.0},
            &Point {x: 3.0, y: 7.0});
        match result {
            Ok(circle) => {
                println!("{}",circle.center.x);
                panic!("collinearity: code claims there is a solution where points are collinear")
            }
            Err(e) => {
                // this is what we expect
                eprintln!("{}",e);
                // panic!("collinearity");
            }
        }
    }

    #[test]
    fn random_triangle() {
        // enter arbitrary values in the next line
        let p1: Point = Point {x: 22.83, y: 2.07};
        let p2: Point = Point {x: 14.39, y: 30.24};
        let p3: Point = Point {x: 33.65, y: 17.31};
        let result = circle_through_3_points_2_d(&p1, &p2, &p3);
        match result {
            Ok(circle) => {
                let distance_p1_center: f64 = ((p1.x-circle.center.x).powf(2.0)+(p1.y-circle.center.y).powf(2.0)).sqrt();
                let distance_p2_center: f64 = ((p2.x-circle.center.x).powf(2.0)+(p2.y-circle.center.y).powf(2.0)).sqrt();
                let distance_p3_center: f64 = ((p3.x-circle.center.x).powf(2.0)+(p3.y-circle.center.y).powf(2.0)).sqrt();
                println!("circle.center_x={}", circle.center.x);
                println!("circle.center_y={}", circle.center.y);
                println!("circle.radius={}", circle.radius);
                println!("distance p1 - center of circle={}", distance_p1_center);
                println!("distance p2 - center of circle={}", distance_p2_center);
                println!("distance p3 - center of circle={}", distance_p3_center);

                assert_f64_near!(distance_p1_center, circle.radius);
                assert_f64_near!(distance_p2_center, circle.radius);
                assert_f64_near!(distance_p3_center, circle.radius);
            }
            Err(e) => {
                eprintln!("{}",e);
                panic!("random_triangle")
            }
        }
    }
}


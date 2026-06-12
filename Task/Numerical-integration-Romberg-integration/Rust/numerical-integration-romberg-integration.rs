use std::error::Error;
use std::fmt;

#[derive(Debug)]
struct InvalidArgumentError(String);

impl fmt::Display for InvalidArgumentError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.0)
    }
}

impl Error for InvalidArgumentError {}

fn romberg_integration<F>(
    func: F,
    mut a: f64,
    mut b: f64,
    max_depth: usize,
    tol: f64,
) -> Result<(f64, usize), Box<dyn Error>>
where
    F: Fn(f64) -> f64,
{
    if max_depth < 1 {
        return Err(Box::new(InvalidArgumentError(
            "maxDepth must be at least 1".to_string(),
        )));
    }

    if a == b {
        return Ok((0.0, 0));
    }

    if a > b {
        std::mem::swap(&mut a, &mut b);
    }

    let mut r = vec![vec![0.0; max_depth + 1]; max_depth + 1];

    r[0][0] = 0.5 * (b - a) * (func(a) + func(b));
    let mut h = b - a;

    for i in 1..=max_depth {
        h /= 2.0;
        let mut sum = 0.0;
        let num_new_points = 1 << (i - 1);

        for k in 1..=num_new_points {
            let x = a + (2 * k - 1) as f64 * h;
            sum += func(x);
        }

        r[i][0] = 0.5 * r[i - 1][0] + sum * h;

        for j in 1..=i {
            let factor = 4.0_f64.powi(j as i32);
            r[i][j] = (factor * r[i][j - 1] - r[i - 1][j - 1]) / (factor - 1.0);
        }

        if (r[i][i] - r[i - 1][i - 1]).abs() < tol {
            return Ok((r[i][i], i));
        }
    }

    Ok((r[max_depth][max_depth], max_depth))
}

fn main() -> Result<(), Box<dyn Error>> {
    let (result1, depth1) = romberg_integration(
        |x| x.sin(),
        0.0,
        1.0,
        10,
        1e-9,
    )?;

    println!(
        "Integral = {:.8} (converged at depth {})",
        result1, depth1
    );

    let (result2, depth2) = romberg_integration(
        |x| x.exp(),
        -3.0,
        3.0,
        10,
        1e-8,
    )?;

    println!(
        "Integral = {:.7} (converged at depth {})",
        result2, depth2
    );

    Ok(())
}

// #[cfg(test)]
// mod tests {
//     use super::*;

//     #[test]
//     fn test_romberg_integration() {
//         let (result, _) = romberg_integration(
//             |x| x.sin(),
//             0.0,
//             std::f64::consts::PI,
//             10,
//             1e-9,
//         ).unwrap();

//         // sin(x) integrated from 0 to π should be 2
//         assert!((result - 2.0).abs() < 1e-8);
//     }

//     #[test]
//     fn test_invalid_max_depth() {
//         let result = romberg_integration(
//             |x| x.sin(),
//             0.0,
//             1.0,
//             0,
//             1e-9,
//         );

//         assert!(result.is_err());
//     }

//     #[test]
//     fn test_equal_bounds() {
//         let (result, depth) = romberg_integration(
//             |x| x.sin(),
//             1.0,
//             1.0,
//             10,
//             1e-9,
//         ).unwrap();

//         assert_eq!(result, 0.0);
//         assert_eq!(depth, 0);
//     }
// }

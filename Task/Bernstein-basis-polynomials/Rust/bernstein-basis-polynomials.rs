use std::vec::Vec;

// Helper function to format Vec<f64> similar to the C++ version
fn vec_to_string(list: &[f64]) -> String {
    let content = list.iter()
                      .map(|x| x.to_string()) // Convert each f64 to String
                      .collect::<Vec<String>>() // Collect into Vec<String>
                      .join(", ");             // Join with ", "
    format!("[{}]", content) // Format into brackets
}

// Subprogram (1)
// Converts monomial basis coefficients to Bernstein basis coefficients (degree 2)
fn monomial_to_bernstein_degree2(monomial: &[f64]) -> Vec<f64> {
    // Assumes monomial.len() >= 3. Panics if not.
    vec![
        monomial[0],
        monomial[0] + (monomial[1] / 2.0),
        monomial[0] + monomial[1] + monomial[2],
    ]
}

// Subprogram (2)
// Evaluates a polynomial in Bernstein basis (degree 2) using de Casteljau's algorithm
fn evaluate_bernstein_degree2(bernstein: &[f64], t: f64) -> f64 {
    // Assumes bernstein.len() >= 3. Panics if not.
    let s = 1.0 - t;
    let b01 = (s * bernstein[0]) + (t * bernstein[1]);
    let b12 = (s * bernstein[1]) + (t * bernstein[2]);
    (s * b01) + (t * b12)
}

// Subprogram (3)
// Converts monomial basis coefficients to Bernstein basis coefficients (degree 3)
fn monomial_to_bernstein_degree3(monomial: &[f64]) -> Vec<f64> {
    // Assumes monomial.len() >= 4. Panics if not.
    vec![
        monomial[0],
        monomial[0] + (monomial[1] / 3.0),
        monomial[0] + (2.0 * monomial[1] / 3.0) + (monomial[2] / 3.0),
        monomial[0] + monomial[1] + monomial[2] + monomial[3],
    ]
}

// Subprogram (4)
// Evaluates a polynomial in Bernstein basis (degree 3) using de Casteljau's algorithm
fn evaluate_bernstein_degree3(bernstein: &[f64], t: f64) -> f64 {
    // Assumes bernstein.len() >= 4. Panics if not.
    let s = 1.0 - t;
    let b01 = (s * bernstein[0]) + (t * bernstein[1]);
    let b12 = (s * bernstein[1]) + (t * bernstein[2]);
    let b23 = (s * bernstein[2]) + (t * bernstein[3]);
    let b012 = (s * b01) + (t * b12);
    let b123 = (s * b12) + (t * b23);
    (s * b012) + (t * b123)
}

// Subprogram (5)
// Elevates the degree of a polynomial in Bernstein basis from 2 to 3
fn bernstein_degree2_to_degree3(bernstein: &[f64]) -> Vec<f64> {
    // Assumes bernstein.len() >= 3. Panics if not.
    vec![
        bernstein[0],
        (bernstein[0] / 3.0) + (2.0 * bernstein[1] / 3.0),
        (2.0 * bernstein[1] / 3.0) + (bernstein[2] / 3.0),
        bernstein[2],
    ]
}

// Evaluates a polynomial in monomial basis (degree 2) using Horner's rule
fn evaluate_monomial_degree2(monomial: &[f64], t: f64) -> f64 {
    // Assumes monomial.len() >= 3. Panics if not.
    monomial[0] + (t * (monomial[1] + (t * monomial[2])))
}

// Evaluates a polynomial in monomial basis (degree 3) using Horner's rule
fn evaluate_monomial_degree3(monomial: &[f64], t: f64) -> f64 {
    // Assumes monomial.len() >= 4. Panics if not.
    monomial[0] + (t * (monomial[1] + (t * (monomial[2] + (t * monomial[3])))))
}


fn main() {
    /**
     * For the following polynomials,
     * use Subprogram (1) to find coefficients in the degree-2 Bernstein basis:
     *
     *  p(x) = 1
     *  q(x) = 1 + 2x + 3x²
     */
    let p_monomial2 = vec![1.0, 0.0, 0.0];
    let q_monomial2 = vec![1.0, 2.0, 3.0];
    let p_bernstein2 = monomial_to_bernstein_degree2(&p_monomial2);
    let q_bernstein2 = monomial_to_bernstein_degree2(&q_monomial2);
    println!("Subprogram (1) examples:");
    println!("    monomial {} --> bernstein {}", vec_to_string(&p_monomial2), vec_to_string(&p_bernstein2));
    println!("    monomial {} --> bernstein {}", vec_to_string(&q_monomial2), vec_to_string(&q_bernstein2));

    /**
     * Use Subprogram (2) to evaluate p(x) and q(x) at x = 0.25, 7.50. Display the results.
     * Optionally also display results from evaluating in the original monomial basis.
     */
    println!("Subprogram (2) examples:");
    for &x in &[0.25, 7.50] {
        println!("    p({}) = {} ( mono: {} )", x, evaluate_bernstein_degree2(&p_bernstein2, x), evaluate_monomial_degree2(&p_monomial2, x));
    }
    for &x in &[0.25, 7.50] {
        println!("    q({}) = {} ( mono: {} )", x, evaluate_bernstein_degree2(&q_bernstein2, x), evaluate_monomial_degree2(&q_monomial2, x));
    }

    /**
     * For the following polynomials,
     * use Subprogram (3) to find coefficients in the degree-3 Bernstein basis:
     *
     *  p(x) = 1
     *  q(x) = 1 + 2x + 3x²
     *  r(x) = 1 + 2x + 3x² + 4x³
     *
     * Display the results.
     */
    let p_monomial3 = vec![1.0, 0.0, 0.0, 0.0];
    let q_monomial3 = vec![1.0, 2.0, 3.0, 0.0];
    let r_monomial3 = vec![1.0, 2.0, 3.0, 4.0];
    let p_bernstein3 = monomial_to_bernstein_degree3(&p_monomial3);
    let q_bernstein3 = monomial_to_bernstein_degree3(&q_monomial3);
    let r_bernstein3 = monomial_to_bernstein_degree3(&r_monomial3);
    println!("Subprogram (3) examples:");
    println!("    monomial {} --> bernstein {}", vec_to_string(&p_monomial3), vec_to_string(&p_bernstein3));
    println!("    monomial {} --> bernstein {}", vec_to_string(&q_monomial3), vec_to_string(&q_bernstein3));
    println!("    monomial {} --> bernstein {}", vec_to_string(&r_monomial3), vec_to_string(&r_bernstein3));

    /**
     * Use Subprogram (4) to evaluate p(x), q(x), and r(x) at x = 0.25, 7.50.  Display the results.
     * Optionally also display results from evaluating in the original monomial basis.
     */
    println!("Subprogram (4) examples:");
    for &x in &[0.25, 7.50] {
        println!("    p({}) = {} ( mono: {} )", x, evaluate_bernstein_degree3(&p_bernstein3, x), evaluate_monomial_degree3(&p_monomial3, x));
    }
    for &x in &[0.25, 7.50] {
        println!("    q({}) = {} ( mono: {} )", x, evaluate_bernstein_degree3(&q_bernstein3, x), evaluate_monomial_degree3(&q_monomial3, x));
    }
    for &x in &[0.25, 7.50] {
        println!("    r({}) = {} ( mono: {} )", x, evaluate_bernstein_degree3(&r_bernstein3, x), evaluate_monomial_degree3(&r_monomial3, x));
    }

    /**
     * For the following polynomials, using the result of Subprogram (1) applied to the polynomial,
     * use Subprogram (5) to get coefficients for the degree-3 Bernstein basis:
     *
     *  p(x) = 1
     *  q(x) = 1 + 2x + 3x²
     *
     * Display the results.
     */
    println!("Subprogram (5) examples:");
    let p_bernstein3a = bernstein_degree2_to_degree3(&p_bernstein2);
    let q_bernstein3a = bernstein_degree2_to_degree3(&q_bernstein2);
    println!("    bernstein {} --> bernstein {}", vec_to_string(&p_bernstein2), vec_to_string(&p_bernstein3a));
    println!("    bernstein {} --> bernstein {}", vec_to_string(&q_bernstein2), vec_to_string(&q_bernstein3a));
}

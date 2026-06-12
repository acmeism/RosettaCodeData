// A Vec<f64> is used to represents a Polynomial
// with its coefficients reversed compared to the standard mathematical notation.
// For example, the polynomial 3x^2 + 2x + 1 is represented by the array [1.0, 2.0, 3.0].

fn add(one: &[f64], two: &[f64]) -> Vec<f64> {
    let max_size = one.len().max(two.len());
    let mut sum = vec![0.0; max_size];

    for i in 0..one.len() {
        sum[i] = one[i];
    }

    for i in 0..two.len() {
        sum[i] += two[i];
    }

    sum
}

fn multiply(one: &[f64], two: &[f64]) -> Vec<f64> {
    let mut product = vec![0.0; one.len() + two.len() - 1];

    for i in 0..one.len() {
        for j in 0..two.len() {
            product[i + j] += one[i] * two[j];
        }
    }

    product
}

fn scalar_multiply(vec: &[f64], value: f64) -> Vec<f64> {
    vec.iter().map(|&d| d * value).collect()
}

fn scalar_divide(vec: &[f64], value: f64) -> Vec<f64> {
    scalar_multiply(vec, 1.0 / value)
}

fn evaluate(vec: &[f64], value: f64) -> f64 {
    let mut result = 0.0;
    for i in (0..vec.len()).rev() {
        result = result * value + vec[i];
    }
    result
}

fn display(vec: &[f64]) {
    let degree = vec.len() - 1;
    if degree == 0 {
        println!("{:.5}", vec[0]);
        return;
    }

    let mut output = String::new();
    for i in (0..=degree).rev() {
        if vec[i] == 0.0 {
            continue;
        }

        let sign = if vec[i] < 0.0 && i == degree {
            "-"
        } else if vec[i] < 0.0 {
            " - "
        } else if i < degree {
            " + "
        } else {
            ""
        };

        output.push_str(sign);

        let coeff = vec[i].abs();
        if coeff > 1.0 {
            output.push_str(&format!("{:.5}", coeff));
        }

        let term = if i > 1 {
            format!("x^{}", i)
        } else if i == 1 {
            "x".to_string()
        } else if coeff == 1.0 {
            "1".to_string()
        } else {
            "".to_string()
        };

        output.push_str(&term);
    }

    println!("{}", output);
}

struct Point {
    x: f64,
    y: f64,
}

fn lagrange_interpolation(points: &[Point]) -> Vec<f64> {
    let mut polys = vec![vec![0.0; points.len()]; points.len()];

    for i in 0..points.len() {
        let mut poly = vec![1.0];

        for j in 0..points.len() {
            if i != j {
                poly = multiply(&poly, &[-points[j].x, 1.0]);
            }
        }

        let value = evaluate(&poly, points[i].x);
        polys[i] = scalar_divide(&poly, value);
    }

    let mut sum = vec![0.0];

    for i in 0..points.len() {
        let scaled_poly = scalar_multiply(&polys[i], points[i].y);
        sum = add(&sum, &scaled_poly);
    }

    sum
}

fn main() {
    let points = vec![
        Point { x: 1.0, y: 1.0 },
        Point { x: 2.0, y: 4.0 },
        Point { x: 3.0, y: 1.0 },
        Point { x: 4.0, y: 5.0 },
    ];

    display(&lagrange_interpolation(&points));
}

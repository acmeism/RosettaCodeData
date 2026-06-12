#[derive(Debug, Clone, Copy)]
struct Point {
    x: f64,
    y: f64,
}

impl Point {
    fn new(x: f64, y: f64) -> Self {
        Point { x, y }
    }
}

fn f(p: &Point) -> f64 {
    (p.x - 1.0) * (p.x - 1.0) * (-p.y * p.y).exp() + p.y * (p.y + 2.0) * (-2.0 * p.x * p.x).exp()
}

fn dfdx(p: &Point) -> f64 {
    2.0 * (p.x - 1.0) * (-p.y * p.y).exp() - 4.0 * p.x * p.y * (p.y + 2.0) * (-2.0 * p.x * p.x).exp()
}

fn dfdy(p: &Point) -> f64 {
    -2.0 * p.y * (p.x - 1.0) * (p.x - 1.0) * (-p.y * p.y).exp() + 2.0 * (p.y + 1.0) * (-2.0 * p.x * p.x).exp()
}

fn gradient_descent(mut minimum: Point, mut alpha: f64, epsilon: f64) -> Point {
    // Calculate initial values
    let mut minimum_function_value = f(&minimum);
    let mut gradient = Point::new(dfdx(&minimum), dfdy(&minimum));

    // Calculate the step size for the first iteration
    let mut delta_gradient = (gradient.x * gradient.x + gradient.y * gradient.y).sqrt();
    let mut step_size = alpha / delta_gradient;

    while delta_gradient > epsilon {
        // Calculate the next value for the minimum point
        minimum = Point::new(
            minimum.x - step_size * gradient.x,
            minimum.y - step_size * gradient.y,
        );

        // Calculate next gradient
        gradient = Point::new(dfdx(&minimum), dfdy(&minimum));

        // Calculate the step size for the next iteration
        delta_gradient = (gradient.x * gradient.x + gradient.y * gradient.y).sqrt();
        step_size = alpha / delta_gradient;

        // Calculate the next function value
        let function_value = f(&minimum);

        // Prepare for the next iteration
        if function_value > minimum_function_value {
            alpha /= 2.0;
        } else {
            minimum_function_value = function_value;
        }
    }

    minimum
}

fn main() {
    const EPSILON: f64 = 0.000_000_1;
    const ALPHA: f64 = 0.1;
    let initial_point = Point::new(0.1, -1.0); // Initial estimate for the location of minimum point

    let minimum = gradient_descent(initial_point, ALPHA, EPSILON);
    println!("Using the gradient descent method the minimum point occurs at:");
    println!("x = {:.6}, y = {:.6} for which f(x, y) = {:.6}",
             minimum.x, minimum.y, f(&minimum));
}

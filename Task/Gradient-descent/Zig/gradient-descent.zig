const std = @import("std");
const math = std.math;
const print = std.debug.print;

const Point = struct {
    x: f64,
    y: f64,
};

fn f(p: Point) f64 {
    return (p.x - 1.0) * (p.x - 1.0) * @exp(-p.y * p.y) + p.y * (p.y + 2.0) * @exp(-2.0 * p.x * p.x);
}

fn dfdx(p: Point) f64 {
    return 2.0 * (p.x - 1.0) * @exp(-p.y * p.y) - 4.0 * p.x * p.y * (p.y + 2.0) * @exp(-2.0 * p.x * p.x);
}

fn dfdy(p: Point) f64 {
    return -2.0 * p.y * (p.x - 1.0) * (p.x - 1.0) * @exp(-p.y * p.y) + 2.0 * (p.y + 1.0) * @exp(-2.0 * p.x * p.x);
}

fn gradient_descent(initial_minimum: Point, initial_alpha: f64, epsilon: f64) Point {
    var minimum = initial_minimum;
    var alpha = initial_alpha;

    // Calculate initial values
    var minimum_function_value = f(minimum);
    var gradient = Point{ .x = dfdx(minimum), .y = dfdy(minimum) };

    // Calculate the step size for the first iteration
    var delta_gradient = @sqrt(gradient.x * gradient.x + gradient.y * gradient.y);
    var step_size = alpha / delta_gradient;

    while (delta_gradient > epsilon) {
        // Calculate the next value for the minimum point
        minimum = Point{
            .x = minimum.x - step_size * gradient.x,
            .y = minimum.y - step_size * gradient.y,
        };

        // Calculate next gradient
        gradient = Point{ .x = dfdx(minimum), .y = dfdy(minimum) };

        // Calculate the step size for the next iteration
        delta_gradient = @sqrt(gradient.x * gradient.x + gradient.y * gradient.y);
        step_size = alpha / delta_gradient;

        // Calculate the next function value
        const function_value = f(minimum);

        // Prepare for the next iteration
        if (function_value > minimum_function_value) {
            alpha /= 2.0;
        } else {
            minimum_function_value = function_value;
        }
    }

    return minimum;
}

pub fn main() void {
    const epsilon = 0.000_000_1;
    const alpha = 0.1;
    const initial_point = Point{ .x = 0.1, .y = -1.0 }; // Initial estimate for the location of minimum point

    const minimum = gradient_descent(initial_point, alpha, epsilon);
    print("Using the gradient descent method the minimum point occurs at:\n" , .{});
    print("x = {d:.6}, y = {d:.6} for which f(x, y) = {d:.6}\n", .{ minimum.x, minimum.y, f(minimum) });
}

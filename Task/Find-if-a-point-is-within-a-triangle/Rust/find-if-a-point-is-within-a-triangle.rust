const EPS: f64 = 0.001;
const EPS_SQUARE: f64 = EPS * EPS;

fn side(x1: f64, y1: f64, x2: f64, y2: f64, x: f64, y: f64) -> f64 {
    (y2 - y1) * (x - x1) + (-x2 + x1) * (y - y1)
}

fn naive_point_in_triangle(x1: f64, y1: f64, x2: f64, y2: f64, x3: f64, y3: f64, x: f64, y: f64) -> bool {
    let check_side1 = side(x1, y1, x2, y2, x, y) >= 0.0;
    let check_side2 = side(x2, y2, x3, y3, x, y) >= 0.0;
    let check_side3 = side(x3, y3, x1, y1, x, y) >= 0.0;
    check_side1 && check_side2 && check_side3
}

fn point_in_triangle_bounding_box(x1: f64, y1: f64, x2: f64, y2: f64, x3: f64, y3: f64, x: f64, y: f64) -> bool {
    let x_min = f64::min(x1, f64::min(x2, x3)) - EPS;
    let x_max = f64::max(x1, f64::max(x2, x3)) + EPS;
    let y_min = f64::min(y1, f64::min(y2, y3)) - EPS;
    let y_max = f64::max(y1, f64::max(y2, y3)) + EPS;
    !(x < x_min || x_max < x || y < y_min || y_max < y)
}

fn distance_square_point_to_segment(x1: f64, y1: f64, x2: f64, y2: f64, x: f64, y: f64) -> f64 {
    let p1_p2_square_length = (x2 - x1).powi(2) + (y2 - y1).powi(2);
    let dot_product = ((x - x1) * (x2 - x1) + (y - y1) * (y2 - y1)) / p1_p2_square_length;
    if dot_product < 0.0 {
        (x - x1).powi(2) + (y - y1).powi(2)
    } else if dot_product <= 1.0 {
        let p_p1_square_length = (x1 - x).powi(2) + (y1 - y).powi(2);
        p_p1_square_length - dot_product.powi(2) * p1_p2_square_length
    } else {
        (x - x2).powi(2) + (y - y2).powi(2)
    }
}

fn accurate_point_in_triangle(x1: f64, y1: f64, x2: f64, y2: f64, x3: f64, y3: f64, x: f64, y: f64) -> bool {
    if !point_in_triangle_bounding_box(x1, y1, x2, y2, x3, y3, x, y) {
        return false;
    }
    if naive_point_in_triangle(x1, y1, x2, y2, x3, y3, x, y) {
        return true;
    }
    if distance_square_point_to_segment(x1, y1, x2, y2, x, y) <= EPS_SQUARE {
        return true;
    }
    if distance_square_point_to_segment(x2, y2, x3, y3, x, y) <= EPS_SQUARE {
        return true;
    }
    if distance_square_point_to_segment(x3, y3, x1, y1, x, y) <= EPS_SQUARE {
        return true;
    }
    false
}

fn print_point(x: f64, y: f64) {
    print!("({}, {})", x, y);
}

fn print_triangle(x1: f64, y1: f64, x2: f64, y2: f64, x3: f64, y3: f64) {
    print!("Triangle is [");
    print_point(x1, y1);
    print!(", ");
    print_point(x2, y2);
    print!(", ");
    print_point(x3, y3);
    println!("]");
}

fn test(x1: f64, y1: f64, x2: f64, y2: f64, x3: f64, y3: f64, x: f64, y: f64) {
    print_triangle(x1, y1, x2, y2, x3, y3);
    print!("Point ");
    print_point(x, y);
    print!(" is within triangle? ");
    println!("{}", accurate_point_in_triangle(x1, y1, x2, y2, x3, y3, x, y));
}

fn main() {
    test(1.5, 2.4, 5.1, -3.1, -3.8, 1.2, 0.0, 0.0);
    println!();

    test(1.5, 2.4, 5.1, -3.1, -3.8, 1.2, 0.0, 1.0);
    println!();

    test(1.5, 2.4, 5.1, -3.1, -3.8, 1.2, 3.0, 1.0);
    println!();

    test(0.1, 0.1111111111111111, 12.5, 33.333333333333336, 25.0, 11.11111111111111, 5.414285714285714, 14.349206349206348);
    println!();

    test(0.1, 0.1111111111111111, 12.5, 33.333333333333336, -12.5, 16.666666666666668, 5.414285714285714, 14.349206349206348);
    println!();
}

import math

const eps = 0.001
const eps_square = eps * eps

fn side(x1 f64, y1 f64, x2 f64, y2 f64, x f64, y f64) f64 {
    return (y2-y1)*(x-x1) + (-x2+x1)*(y-y1)
}

fn native_point_in_triangle(x1 f64, y1 f64, x2 f64, y2 f64, x3 f64, y3 f64, x f64, y f64) bool {
    check_side1 := side(x1, y1, x2, y2, x, y) >= 0
    check_side2 := side(x2, y2, x3, y3, x, y) >= 0
    check_side3 := side(x3, y3, x1, y1, x, y) >= 0
    return check_side1 && check_side2 && check_side3
}

fn point_in_triangle_bounding_box(x1 f64, y1 f64, x2 f64, y2 f64, x3 f64, y3 f64, x f64, y f64) bool {
    x_min := math.min(x1, math.min(x2, x3)) - eps
    x_max := math.max(x1, math.max(x2, x3)) + eps
    y_min := math.min(y1, math.min(y2, y3)) - eps
    y_max := math.max(y1, math.max(y2, y3)) + eps
    return !(x < x_min || x_max < x || y < y_min || y_max < y)
}

fn distance_square_point_to_segment(x1 f64, y1 f64, x2 f64, y2 f64, x f64, y f64) f64 {
    pq_p2_square_length := (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1)
    dot_product := ((x-x1)*(x2-x1) + (y-y1)*(y2-y1)) / pq_p2_square_length
    if dot_product < 0 {
        return (x-x1)*(x-x1) + (y-y1)*(y-y1)
    } else if dot_product <= 1 {
        p_p1_square_length := (x1-x)*(x1-x) + (y1-y)*(y1-y)
        return p_p1_square_length - dot_product*dot_product*pq_p2_square_length
    } else {
        return (x-x2)*(x-x2) + (y-y2)*(y-y2)
    }
}

fn accurate_point_in_triangle(x1 f64, y1 f64, x2 f64, y2 f64, x3 f64, y3 f64, x f64, y f64) bool {
    if !point_in_triangle_bounding_box(x1, y1, x2, y2, x3, y3, x, y) {
        return false
    }
    if native_point_in_triangle(x1, y1, x2, y2, x3, y3, x, y) {
        return true
    }
    if distance_square_point_to_segment(x1, y1, x2, y2, x, y) <= eps_square {
        return true
    }
    if distance_square_point_to_segment(x2, y2, x3, y3, x, y) <= eps_square {
        return true
    }
    if distance_square_point_to_segment(x3, y3, x1, y1, x, y) <= eps_square {
        return true
    }
    return false
}

fn main() {
    pts := [[f64(0), 0], [f64(0), 1], [f64(3), 1]]
    mut tri := [[3.0 / 2, 12.0 / 5], [51.0 / 10, -31.0 / 10], [-19.0 / 5, 1.2]]
    println("Triangle is $tri")
    mut x1, mut y1 := tri[0][0], tri[0][1]
    mut x2, mut y2 := tri[1][0], tri[1][1]
    mut x3, mut y3 := tri[2][0], tri[2][1]
    for pt in pts {
        x, y := pt[0], pt[1]
        within := accurate_point_in_triangle(x1, y1, x2, y2, x3, y3, x, y)
        println("Point $pt is within triangle? $within")
    }
    println('')
    tri = [[1.0 / 10, 1.0 / 9], [100.0 / 8, 100.0 / 3], [100.0 / 4, 100.0 / 9]]
    println("Triangle is $tri")
    x1, y1 = tri[0][0], tri[0][1]
    x2, y2 = tri[1][0], tri[1][1]
    x3, y3 = tri[2][0], tri[2][1]
    x := x1 + (3.0/7)*(x2-x1)
    y := y1 + (3.0/7)*(y2-y1)
    pt := [x, y]
    mut within := accurate_point_in_triangle(x1, y1, x2, y2, x3, y3, x, y)
    println("Point $pt is within triangle ? $within")
    println('')
    tri = [[1.0 / 10, 1.0 / 9], [100.0 / 8, 100.0 / 3], [-100.0 / 8, 100.0 / 6]]
    println("Triangle is $tri")
    x3 = tri[2][0]
    y3 = tri[2][1]
    within = accurate_point_in_triangle(x1, y1, x2, y2, x3, y3, x, y)
    println("Point $pt is within triangle ? $within")
}

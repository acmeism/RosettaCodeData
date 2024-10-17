struct Point {
    x: i32,
    y: i32
}

fn main() {
    let mut points: Vec<Point> = Vec::new();
    points.append(&mut get_coordinates(1, 20, 20, 28));
    points.append(&mut get_coordinates(20, 28, 69, 0));
    draw_line(points, 70, 30);
}

fn get_coordinates(x1: i32, y1: i32, x2: i32, y2: i32) -> Vec<Point> {
    let mut coordinates: Vec<Point> = vec![];
    let dx:i32 = i32::abs(x2 - x1);
    let dy:i32 = i32::abs(y2 - y1);
    let sx:i32 = { if x1 < x2 { 1 } else { -1 } };
    let sy:i32 = { if y1 < y2 { 1 } else { -1 } };

    let mut error:i32 = (if dx > dy  { dx } else { -dy }) / 2 ;
    let mut current_x:i32 = x1;
    let mut current_y:i32 = y1;
    loop {
        coordinates.push(Point { x : current_x, y: current_y });

        if current_x == x2 && current_y == y2 { break; }

        let error2:i32 = error;

        if error2 > -dx {
            error -= dy;
            current_x += sx;
        }
        if error2 < dy {
            error += dx;
            current_y += sy;
        }
    }
    coordinates
}

fn draw_line(line: std::vec::Vec<Point>, width: i32, height: i32) {
    for col in 0..height {
        for row in 0..width {
            let is_point_in_line = line.iter().any(| point| point.x == row && point.y == col);
            match is_point_in_line {
                true => print!("@"),
                _ => print!(".")
            };
        }
        print!("\n");
    }
}

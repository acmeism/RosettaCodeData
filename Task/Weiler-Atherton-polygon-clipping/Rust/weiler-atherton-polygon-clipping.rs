use std::f64::EPSILON;
use std::cmp::Ordering;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct Point {
    x: i32,
    y: i32,
}

#[derive(Debug, Clone)]
struct Line {
    start: Point,
    end: Point,
}

#[derive(Debug, Clone)]
struct Polygon {
    points: Vec<Point>,
}

#[derive(Debug, Clone, Copy, PartialEq)]
enum InterVertexType {
    InsideVertex,
    OutsideVertex,
    InIntersection,
    OutIntersection,
}

#[derive(Debug, Clone)]
struct InterVertex {
    vertex_type: InterVertexType,
    point: Point,
}

impl InterVertex {
    fn get_point(&self) -> Point {
        self.point
    }

    fn get_first_in_intersection(list: &mut Vec<InterVertex>) -> Option<Point> {
        let pos = list.iter().position(|v| v.vertex_type == InterVertexType::InIntersection);
        if let Some(found) = pos {
            let result = list[found].point;
            list.drain(0..found);
            Some(result)
        } else {
            None
        }
    }
}

#[derive(Debug, PartialEq)]
enum PolyListOptionType {
    List,
    InsidePoly,
    None,
}

#[derive(Debug)]
struct PolyListOption {
    option_type: PolyListOptionType,
    inter_vertex_list: Vec<InterVertex>,
    points: Vec<Point>,
}

fn is_in_polygon(point: Point, poly: &Polygon) -> bool {
    let x = point.x;
    let y = point.y;
    let mut inside = false;
    let mut j = poly.points.len() - 1;

    for i in 0..poly.points.len() {
        let xi = poly.points[i].x;
        let yi = poly.points[i].y;
        let xj = poly.points[j].x;
        let yj = poly.points[j].y;

        let intersect = ((yi > y) != (yj > y)) &&
            (x as f64) < (xj - xi) as f64 * (y - yi) as f64 / (yj - yi) as f64 + xi as f64;

        if intersect {
            inside = !inside;
        }
        j = i;
    }

    inside
}

fn distance_cmp(reference: Point, first: Point, second: Point) -> Ordering {
    let dist_first = (reference.x - first.x).abs() + (reference.y - first.y).abs();
    let dist_second = (reference.x - second.x).abs() + (reference.y - second.y).abs();
    dist_first.cmp(&dist_second)
}

fn is_in_line(point: Point, line: &Line) -> bool {
    let dxc = point.x - line.start.x;
    let dyc = point.y - line.start.y;
    let dxl = line.end.x - line.start.x;
    let dyl = line.end.y - line.start.y;
    let cross = dxc * dyl - dyc * dxl;

    if cross != 0 {
        return false;
    }

    if dxl.abs() >= dyl.abs() {
        if dxl > 0 {
            line.start.x <= point.x && point.x <= line.end.x
        } else {
            line.end.x <= point.x && point.x <= line.start.x
        }
    } else if dyl > 0 {
        line.start.y <= point.y && point.y <= line.end.y
    } else {
        line.end.y <= point.y && point.y <= line.start.y
    }
}

fn get_intersection(line1: &Line, line2: &Line) -> Option<Point> {
    let p0 = line1.start;
    let p1 = line1.end;
    let p2 = line2.start;
    let p3 = line2.end as Point;

    let s10_x = (p1.x - p0.x) as f64;
    let s10_y = (p1.y - p0.y) as f64;
    let s32_x = (p3.x - p2.x) as f64;
    let s32_y = (p3.y - p2.y) as f64;

    let denom = s10_x * s32_y - s32_x * s10_y;
    if denom.abs() < EPSILON {
        return None;
    }

    let s02_x = (p0.x - p2.x) as f64;
    let s02_y = (p0.y - p2.y) as f64;

    let s_numer = s10_x * s02_y - s10_y * s02_x;
    let t_numer = s32_x * s02_y - s32_y * s02_x;

    let s = s_numer / denom;
    let t = t_numer / denom;

    if s < 0.0 || s > 1.0 || t < 0.0 || t > 1.0 {
        return None;
    }

    let x = p0.x as f64 + t * s10_x;
    let y = p0.y as f64 + t * s10_y;

    Some(Point {
        x: x.round() as i32,
        y: y.round() as i32,
    })
}

fn is_clockwise(poly: &Polygon) -> bool {
    let mut sum = 0;
    for i in 0..poly.points.len() {
        let j = (i + 1) % poly.points.len();
        sum += (poly.points[j].x - poly.points[i].x) * (poly.points[j].y + poly.points[i].y);
    }
    sum < 0
}

fn get_reversed(poly: &Polygon) -> Polygon {
    let mut reversed = poly.points.clone();
    reversed.reverse();
    Polygon { points: reversed }
}

fn get_first_outside_vertex_index(subject: &Polygon, clip: &Polygon) -> Option<usize> {
    subject.points
        .iter()
        .position(|&p| !is_in_polygon(p, clip))
}

fn get_first_inside_vertex_index(subject: &Polygon, clip: &Polygon) -> Option<usize> {
    subject.points
        .iter()
        .position(|&p| is_in_polygon(p, clip))
}

fn get_intersections_with_line(
    poly: &Polygon,
    line: &Line,
    cursor_inside: &mut bool,
) -> Vec<InterVertex> {
    let mut intersections = Vec::new();

    for i in 0..poly.points.len() {
        let j = (i + 1) % poly.points.len();
        let edge = Line {
            start: poly.points[i],
            end: poly.points[j],
        };

        if let Some(pt) = get_intersection(&edge, line) {
            if pt != line.start && pt != line.end && pt != edge.start && pt != edge.end {
                intersections.push(pt);
            }
        }
    }

    intersections.sort_by(|&a, &b| distance_cmp(line.start, a, b));

    let mut result = Vec::new();
    for pt in intersections {
        let vertex_type = if *cursor_inside {
            InterVertexType::OutIntersection
        } else {
            InterVertexType::InIntersection
        };
        *cursor_inside = !*cursor_inside;
        result.push(InterVertex {
            vertex_type,
            point: pt,
        });
    }

    result
}

fn get_inter_vertex_list(subject: &Polygon, clip: &Polygon) -> PolyListOption {
    let mut subject_copy = subject.clone();
    if !is_clockwise(&subject_copy) {
        subject_copy = get_reversed(&subject_copy);
    }

    if let Some(start_index) = get_first_outside_vertex_index(&subject_copy, clip) {
        if get_first_inside_vertex_index(&subject_copy, clip).is_none() {
            if clip.points.iter().all(|&p| is_in_polygon(p, &subject_copy)) {
                return PolyListOption {
                    option_type: PolyListOptionType::InsidePoly,
                    inter_vertex_list: Vec::new(),
                    points: clip.points.clone(),
                };
            }
        }

        let mut cursor_inside = false;
        let mut result = Vec::new();

        for offset in 0..subject_copy.points.len() {
            let i = (start_index + offset) % subject_copy.points.len();
            let point = subject_copy.points[i];

            let vertex_type = if offset == 0 || !is_in_polygon(point, clip) {
                InterVertexType::OutsideVertex
            } else {
                InterVertexType::InsideVertex
            };
            result.push(InterVertex {
                vertex_type,
                point,
            });

            let j = (i + 1) % subject_copy.points.len();
            let next_point = subject_copy.points[j];
            let line = Line {
                start: point,
                end: next_point,
            };

            let mut intersections = get_intersections_with_line(clip, &line, &mut cursor_inside);
            result.append(&mut intersections);
        }

        let has_intersections = result.iter().any(|v| {
            v.vertex_type == InterVertexType::InIntersection ||
            v.vertex_type == InterVertexType::OutIntersection
        });

        if has_intersections {
            PolyListOption {
                option_type: PolyListOptionType::List,
                inter_vertex_list: result,
                points: Vec::new(),
            }
        } else {
            PolyListOption {
                option_type: PolyListOptionType::None,
                inter_vertex_list: Vec::new(),
                points: Vec::new(),
            }
        }
    } else {
        PolyListOption {
            option_type: PolyListOptionType::InsidePoly,
            inter_vertex_list: Vec::new(),
            points: subject.points.clone(),
        }
    }
}

fn collect_from_list(list: &mut Vec<InterVertex>, start_point: Point) -> Option<(Vec<Point>, Point)> {
    let mut start_index = None;
    for (i, vertex) in list.iter().enumerate() {
        if vertex.vertex_type == InterVertexType::InIntersection &&
            vertex.point == start_point
        {
            start_index = Some(i);
            break;
        }
    }

    let start_i = start_index?;
    let mut points = Vec::new();
    let mut end_i = start_i;
    let mut last_point = None;

    for (i, vertex) in list.iter().enumerate().skip(start_i) {
        if vertex.vertex_type == InterVertexType::OutIntersection {
            last_point = Some(vertex.point);
            end_i = i;
            break;
        }
        points.push(vertex.point);
    }

    if last_point.is_none() {
        return None;
    }

    let amount = end_i - start_i + 1;
    if end_i >= start_i {
        list.drain(start_i..=end_i);
    }

    Some((points, last_point.unwrap()))
}

fn get_clip_polygon(
    subject: &mut Vec<InterVertex>,
    clip: &mut Vec<InterVertex>,
    initial: Point,
) -> Option<Vec<Point>> {
    let mut result = Vec::new();
    let mut subject_as_list = true;
    let mut start_point = initial;
    let mut end_point = subject.last().unwrap().point;

    while initial != end_point {
        let values = if subject_as_list {
            collect_from_list(subject, start_point)
        } else {
            collect_from_list(clip, start_point)
        };

        if let Some((edges, end)) = values {
            end_point = end;
            start_point = end;
            subject_as_list = !subject_as_list;
            result.extend(edges);
        } else {
            eprintln!("Error: Failed to collect edges");
            return None;
        }
    }

    result.dedup();
    Some(result)
}

fn get_clip_polygons(
    subject: &mut Vec<InterVertex>,
    clip: &mut Vec<InterVertex>,
) -> Option<Vec<Vec<Point>>> {
    let mut result = Vec::new();

    while let Some(start_point) = InterVertex::get_first_in_intersection(subject) {
        if let Some(poly) = get_clip_polygon(subject, clip, start_point) {
            result.push(poly);
        } else {
            break;
        }
    }

    if result.is_empty() {
        None
    } else {
        Some(result)
    }
}

pub fn clip(subject: &Polygon, clip: &Polygon) -> Option<Vec<Vec<Point>>> {
    let subject_option = get_inter_vertex_list(subject, clip);
    let clip_option = get_inter_vertex_list(clip, subject);

    match subject_option.option_type {
        PolyListOptionType::List => {
            let mut subject_list = subject_option.inter_vertex_list;
            match clip_option.option_type {
                PolyListOptionType::List => {
                    let mut clip_list = clip_option.inter_vertex_list;
                    get_clip_polygons(&mut subject_list, &mut clip_list)
                }
                PolyListOptionType::InsidePoly => Some(vec![clip_option.points]),
                _ => None,
            }
        }
        PolyListOptionType::InsidePoly => Some(vec![subject_option.points]),
        _ => None,
    }
}

// Test function
fn run_tests() {
    // Test is_in_line
    {
        let p = Point { x: 5, y: 10 };
        let line = Line {
            start: Point { x: 5, y: 5 },
            end: Point { x: 5, y: 20 },
        };
        let result = is_in_line(p, &line);
        println!("is_in_line test 1: {}", if result { "PASS" } else { "FAIL" });

        let p_f = Point { x: 3, y: 4 };
        let line_f = Line {
            start: Point { x: 5, y: 5 },
            end: Point { x: 5, y: 20 },
        };
        let result_f = is_in_line(p_f, &line_f);
        println!("is_in_line test 2: {}", if !result_f { "PASS" } else { "FAIL" });
    }

    // Test clip
    {
        let poly = Polygon {
            points: vec![
                Point { x: 180, y: 420 },
                Point { x: 180, y: 120 },
                Point { x: 520, y: 120 },
                Point { x: 520, y: 420 },
                Point { x: 420, y: 420 },
                Point { x: 320, y: 220 },
            ],
        };

        let inter_polygon = Polygon {
            points: vec![
                Point { x: 60, y: 220 },
                Point { x: 330, y: 120 },
                Point { x: 410, y: 290 },
                Point { x: 80, y: 480 },
                Point { x: 280, y: 280 },
            ],
        };

        if let Some(polygons) = clip(&poly, &inter_polygon) {
            println!("clip test: PASS - Found {} polygons", polygons.len());
            if let Some(first_poly) = polygons.first() {
                println!("First polygon points:");
                for p in first_poly {
                    println!("  Point: ({}, {})", p.x, p.y);
                }
            }
        } else {
            println!("clip test: FAIL - No polygons found");
        }
    }
}

fn main() {
    run_tests();
}

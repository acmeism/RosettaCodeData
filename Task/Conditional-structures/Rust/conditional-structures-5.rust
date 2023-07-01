fn some_other_function(p: Option<Point>) {
    match p {
        Some(Point { x: 0, y: 0 }) => println!("Point is on origin"),
        Some(Point { x: 0, y: _ }) | Some(Point { x: _, y: 0 }) => println!("Point is on an axis"),
        Some(Point {x: a, y: b}) if a == b => println!("x and y are the same value"),
        Some(Point {x: ref mut a, y: ref b}) if *a > 4 && *b < 2 => println!("we got a mutable reference to x-value and an immutable reference to y-value."),
        op @ Some(p) => println!("op is the Option<Point> while p is the contained Point"),
        None => println!("We didn't get a point"),
    }
}

fn sudan1(n: usize, x: usize, y: usize) -> usize {
    match (n, y) {
        (0, _) => x + y,
        (_, 0) => x,
        _ => sudan1(n - 1, sudan1(n, x, y - 1), sudan1(n, x, y - 1) + y)
    }
}

fn sudan2(n: usize, x: usize, y: usize) -> usize {
    if n == 0 { x + y }
    else if y == 0 { x }
    else {
        sudan2(n - 1, sudan2(n, x, y - 1), sudan2(n, x, y - 1) + y)
    }
}

use once_cell::sync::Lazy;

const GRID_SIZE: usize = 15;
static mut CANVAS: Lazy<Vec<[char; GRID_SIZE]>> = Lazy::new(|| vec![[' '; GRID_SIZE]; GRID_SIZE],);

/// initialize CANVAS
fn init_n() {
    for i in 0..GRID_SIZE {
        for j in 0..GRID_SIZE {
            unsafe { CANVAS[i][j] = ' '; }
        }
        unsafe { CANVAS[i][5] = '#'; }
    }
}

/// draw horizontal
fn horizontal(c1: usize, c2: usize, r: usize) {
    for c in c1..=c2 {
        unsafe { CANVAS[r][c] = '#'; }
    }
}

/// draw vertical
fn vertical(r1: usize, r2: usize, c: usize) {
    for r in r1..=r2 {
        unsafe { CANVAS[r][c] = '#'; }
    }
}

/// draw diagonal NE to SW
fn diag_d(c1 : usize, c2: usize, r: usize) {
    for c in c1..=c2 {
        unsafe { CANVAS[r + c - c1][c] = '#'; }
    }
}

/// draw diagonal SE to NW
fn diag_u(c1: usize, c2: usize, r: usize) {
    for c in c1..=c2 {
        unsafe { CANVAS[r + c1 - c][c] = '#'; }
    }
}

/// Mark the portions of the ones place.
fn draw_ones(v: i32) {
    match v {
        1 => horizontal(6, 10, 0),
        2 => horizontal(6, 10, 4),
        3 => diag_d(6, 10, 0),
        4 => diag_u(6, 10, 4),
        5 => { draw_ones(1); draw_ones(4); },
        6 => vertical(0, 4, 10),
        7 => { draw_ones(1); draw_ones(6); },
        8 => { draw_ones(2); draw_ones(6); },
        9 => { draw_ones(1); draw_ones(8); },
        _ => {},
    }
}

/// Mark the portions of the tens place.
fn draw_tens(v: i32) {
    match v {
        1 => horizontal(0, 4, 0),
        2 => horizontal(0, 4, 4),
        3 => diag_u(0, 4, 4),
        4 => diag_d(0, 4, 0),
        5 => { draw_tens(1); draw_tens(4); },
        6 => vertical(0, 4, 0),
        7 => { draw_tens(1); draw_tens(6); },
        8 => { draw_tens(2); draw_tens(6); },
        9 => { draw_tens(1); draw_tens(8); },
        _ => {},
    }
}

/// Mark the portions of the hundreds place.
fn draw_hundreds(hundreds: i32) {
    match hundreds {
        1 => horizontal(6, 10, 14),
        2 => horizontal(6, 10, 10),
        3 => diag_u(6, 10, 14),
        4 => diag_d(6, 10, 10),
        5 => { draw_hundreds(1); draw_hundreds(4) },
        6 => vertical(10, 14, 10),
        7 => { draw_hundreds(1); draw_hundreds(6); },
        8 => { draw_hundreds(2); draw_hundreds(6); },
        9 => { draw_hundreds(1); draw_hundreds(8); },
        _ => {},
    }
}

/// Mark the portions of the thousands place.
fn draw_thousands(thousands: i32) {
    match thousands {
        1 => horizontal(0, 4, 14),
        2 => horizontal(0, 4, 10),
        3 => diag_d(0, 4, 10),
        4 => diag_u(0, 4, 14),
        5 => { draw_thousands(1); draw_thousands(4); },
        6 => vertical(10, 14, 0),
        7 => { draw_thousands(1); draw_thousands(6); },
        8 => { draw_thousands(2); draw_thousands(6); },
        9 => { draw_thousands(1); draw_thousands(8); },
        _ => {},
    }
}

/// Mark the char matrix for the numeral drawing.
fn draw(mut v: i32) {
    let thousands: i32 = v / 1000;
    v %= 1000;
    let hundreds: i32 = v / 100;
    v %= 100;
    let tens: i32 = v / 10;
    let ones: i32 = v % 10;
    if thousands > 0 {
        draw_thousands(thousands);
    }
    if hundreds > 0 {
        draw_hundreds(hundreds);
    }
    if tens > 0 {
        draw_tens(tens);
    }
    if ones > 0 {
        draw_ones(ones);
    }
}

/// Test the drawings as outout to stdout.
fn test_output(n: i32) {
    println!("{n}");
    init_n();
    draw(n);
    unsafe {
        for line in CANVAS.iter() {
            for c in line.iter() {
                print!("{}", *c);
            }
            println!();
        }
    }
    println!("\n");
}

fn main() {
    for n in [0, 1, 20, 300, 2022, 4000, 5555, 6789, 9999] {
        test_output(n);
    }
}

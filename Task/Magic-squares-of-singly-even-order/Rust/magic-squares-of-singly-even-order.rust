use std::env;

fn main() {
    let n: usize =
        match env::args().nth(1).and_then(|arg| arg.parse().ok()).ok_or(
            "Please specify the size of the magic square, as a positive multiple of 4 plus 2.",
        ) {
            Ok(arg) if arg % 2 == 1 || arg >= 6 && (arg - 2) % 4 == 0 => arg,
            Err(e) => panic!(e),
            _ => panic!("Argument must be a positive multiple of 4 plus 2."),
        };

    let (ms, mc) = magic_square_singly_even(n);
    println!("n: {}", n);
    println!("Magic constant: {}\n", mc);
    let width = (n * n).to_string().len() + 1;
    for row in ms {
        for elem in row {
            print!("{e:>w$}", e = elem, w = width);
        }
        println!();
    }
}

fn magic_square_singly_even(n: usize) -> (Vec<Vec<usize>>, usize) {
    let size = n * n;
    let half = n / 2;
    let sub_square_size = size / 4;
    let sub_square = magic_square_odd(half);
    let quadrant_factors = [0, 2, 3, 1];
    let cols_left = half / 2;
    let cols_right = cols_left - 1;

    let ms = (0..n)
        .map(|r| {
            (0..n)
                .map(|c| {
                    let localr = if (c < cols_left
                        || c >= n - cols_right
                        || c == cols_left && r % half == cols_left)
                        && !(c == 0 && r % half == cols_left)
                    {
                        if r >= half {
                            r - half
                        } else {
                            r + half
                        }
                    } else {
                        r
                    };
                    let quadrant = localr / half * 2 + c / half;
                    let v = sub_square[localr % half][c % half];
                    v + quadrant_factors[quadrant] * sub_square_size
                })
                .collect()
        })
        .collect::<Vec<Vec<_>>>();
    (ms, (n * n + 1) * n / 2)
}

fn magic_square_odd(n: usize) -> Vec<Vec<usize>> {
    (0..n)
        .map(|r| {
            (0..n)
                .map(|c| {
                    n * (((c + 1) + (r + 1) - 1 + (n >> 1)) % n)
                        + (((c + 1) + (2 * (r + 1)) - 2) % n)
                        + 1
                })
                .collect::<Vec<_>>()
        })
        .collect::<Vec<Vec<_>>>()
}

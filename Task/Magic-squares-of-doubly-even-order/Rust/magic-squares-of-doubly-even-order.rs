use std::env;

fn main() {
    let n: usize = match env::args()
        .nth(1)
        .and_then(|arg| arg.parse().ok())
        .ok_or("Please specify the size of the magic square, as a positive multiple of 4.")
    {
        Ok(arg) if arg >= 4 && arg % 4 == 0 => arg,
        Err(e) => panic!(e),
        _ => panic!("Argument must be a positive multiple of 4."),
    };

    let mc = (n * n + 1) * n / 2;
    println!("Magic constant: {}\n", mc);
    let bits = 0b1001_0110_0110_1001u32;
    let size = n * n;
    let width = size.to_string().len() + 1;
    let mult = n / 4;
    let mut i = 0;
    for r in 0..n {
        for c in 0..n {
            let bit_pos = c / mult + (r / mult) * 4;
            print!(
                "{e:>w$}",
                e = if bits & (1 << bit_pos) != 0 {
                    i + 1
                } else {
                    size - i
                },
                w = width
            );
            i += 1;
        }
        println!();
    }
}

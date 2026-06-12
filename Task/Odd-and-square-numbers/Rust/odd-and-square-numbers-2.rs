fn main() {
    // We don't want to consume the next item in the iterator once it passes a power of 10
    let mut odd_squares = core::iter::successors(Some([1, 8]), |&[acc, x]| Some([acc + x, x + 8]))
        .map(|[x, _]| x)
        .peekable();

    for [lo, hi] in core::iter::successors(Some([1, 10]), |&[_, hi]| Some([hi, hi * 10])).take(5) {
        println!("odd squares from {lo} to {hi}:");

        let mut row = core::iter::repeat_n(" ", 9);

        while let Some(i) = odd_squares.next_if(|&x| x < hi) {
            let s = row.next().unwrap_or_else(|| {
                row = core::iter::repeat_n(" ", 9);

                "\n"
            });

            print!("{i}{s}");
        }

        println!("\n");
    }
}


fn main() {
    let odd_squares =
        core::iter::successors(Some([1, 8]), |[acc, x]| Some([acc + x, x + 8])).map(|[x, _]| x);

    for i in odd_squares
        .skip_while(|&x| x < 100)
        .take_while(|&x| x < 1000)
    {
        println!("{i}");
    }
}


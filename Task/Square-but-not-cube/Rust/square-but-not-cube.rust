fn main() {
    let mut s = 1;
    let mut c = 1;
    let mut cube = 1;
    let mut n = 0;
    while n < 30 {
        let square = s * s;
        while cube < square {
            c += 1;
            cube = c * c * c;
        }
        if cube == square {
            println!("{} is a square and a cube.", square);
        } else {
            println!("{}", square);
            n += 1;
        }
        s += 1;
    }
}

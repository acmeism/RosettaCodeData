const LIMIT: i32 = 12;

fn main() {
    for i in 1..LIMIT+1 {
        print!("{:3}{}", i, if LIMIT - i == 0 {'\n'} else {' '})
    }
    for i in 0..LIMIT+1 {
        print!("{}", if LIMIT - i == 0 {"+\n"} else {"----"});
    }

    for i in 1..LIMIT+1 {
        for j in 1..LIMIT+1 {
            if j < i {
                print!("    ")
            } else {
                print!("{:3} ", j * i)
            }
        }
        println!("| {}", i);
    }
}

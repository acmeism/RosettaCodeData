fn gray_encode(integer: u64) -> u64 {
    (integer >> 1) ^ integer
}

fn gray_decode(integer: u64) -> u64 {
    match integer {
        0 => 0,
        _ => integer ^ gray_decode(integer >> 1)
    }
}

fn main() {
    for i in 0..32 {
        println!("{:2} {:0>5b} {:0>5b} {:2}", i, i, gray_encode(i),
            gray_decode(i));
    }

}

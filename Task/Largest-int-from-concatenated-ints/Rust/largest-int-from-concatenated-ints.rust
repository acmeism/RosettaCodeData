fn maxcat(a: &mut [u32]) {
    a.sort_by(|x, y| {
        let xy = format!("{}{}", x, y);
        let yx = format!("{}{}", y, x);
        xy.cmp(&yx).reverse()
    });
    for x in a {
        print!("{}", x);
    }
    println!();
}

fn main() {
    maxcat(&mut [1, 34, 3, 98, 9, 76, 45, 4]);
    maxcat(&mut [54, 546, 548, 60]);
}

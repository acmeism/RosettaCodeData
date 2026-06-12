// [dependencies]
// rug = "1.9"

fn shorten(s: &str, digits: usize) -> String {
    if s.len() <= digits + 3 {
        return String::from(s);
    }
    format!("{}...{}", &s[0..digits/2], &s[s.len()-digits/2..])
}

fn main() {
    use rug::{ops::Pow, Integer};

    let x = Integer::from(8);
    let r = Integer::from(x.root_ref(3));
    println!("Integer cube root of {}: {}", x, r);

    let x = Integer::from(9);
    let r = Integer::from(x.root_ref(3));
    println!("Integer cube root of {}: {}", x, r);

    let mut x = Integer::from(100).pow(2000);
    x *= 2;
    let s = Integer::from(x.root(2)).to_string();
    println!("First {} digits of the square root of 2:\n{}", s.len(), shorten(&s, 70));

    let mut x = Integer::from(100).pow(3000);
    x *= 2;
    let s = Integer::from(x.root(3)).to_string();
    println!("First {} digits of the cube root of 2:\n{}", s.len(), shorten(&s, 70));
}

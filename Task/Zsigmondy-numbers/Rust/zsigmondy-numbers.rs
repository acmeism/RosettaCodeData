use itertools::{max, all};
use gcd::Gcd;
use divisors::get_divisors;

fn zsigmondy(a: u64, b: u64, n: u64) -> u64 {
    assert!(a > b);
    let dexpms: Vec<u64> = (1..(n as u32)).map(|i| a.pow(i) - b.pow(i)).collect();
    let dexpn: u64 = a.pow(n as u32) - b.pow(n as u32);
    let mut divisors = get_divisors(dexpn).to_vec(); // get_divisors(n) does not include 1 and n
    divisors.append(&mut [1, dexpn].to_vec());       // so add those
    let z = divisors.iter().filter(|d| all(dexpms.clone(), |k| Gcd::gcd(k, **d) == 1));
    return *max(z).unwrap();
}

fn main() {
    for (name, a, b) in [
        ("A064078: Zsigmondy(n,2,1)", 2, 1,),
        ("A064079: Zsigmondy(n,3,1)", 3, 1,),
        ("A064080: Zsigmondy(n,4,1)", 4, 1,),
        ("A064081: Zsigmondy(n,5,1)", 5, 1,),
        ("A064082: Zsigmondy(n,6,1)", 6, 1,),
        ("A064083: Zsigmondy(n,7,1)", 7, 1,),
        ("A109325: Zsigmondy(n,3,2)", 3, 2,),
        ("A109347: Zsigmondy(n,5,3)", 5, 3,),
        ("A109348: Zsigmondy(n,7,3)", 7, 3,),
        ("A109349: Zsigmondy(n,7,5)", 7, 5,),] {
        println!("\n{name}:");
        for n in 1..21 {
            print!("{} ", zsigmondy(a, b, n));
        }
    }
}

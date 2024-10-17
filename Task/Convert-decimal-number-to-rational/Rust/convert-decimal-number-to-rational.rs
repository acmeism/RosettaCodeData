extern crate rand;
extern crate num;

use num::Integer;
use rand::Rng;

fn decimal_to_rational (mut n : f64) -> [isize;2] {
    //Based on Farey sequences
    assert!(n.is_finite());
    let flag_neg  = n < 0.0;
    if flag_neg { n = n*(-1.0) }
    if n < std::f64::MIN_POSITIVE { return [0,1] }
    if (n - n.round()).abs() < std::f64::EPSILON { return [n.round() as isize, 1] }
    let mut a : isize = 0;
    let mut b : isize = 1;
    let mut c : isize = n.ceil() as isize;
    let mut d : isize = 1;
    let aux1 = isize::max_value()/2;
    while c < aux1  && d < aux1 {
        let aux2 : f64 = (a as f64 + c as f64)/(b as f64 + d as f64);
        if (n - aux2).abs() < std::f64::EPSILON { break }
        if n > aux2 {
            a = a + c;
            b = b + d;
        } else {
            c = a + c;
            d = b + d;
        }
    }
    // Make sure that the fraction is irreducible
    let gcd = (a+c).gcd(&(b+d));
    if flag_neg { [-(a + c)/gcd, (b + d)/gcd] } else { [(a + c)/gcd, (b + d)/gcd] }
}

#[test]
fn test1 () {
    // Test the function with 1_000_000 random decimal numbers
    let mut rng = rand::thread_rng();
    for _i in 1..1_000_000 {
        let number = rng.gen::<f64>();
        let result = decimal_to_rational(number);
        assert!((number - (result[0] as f64)/(result[1] as f64)).abs() < std::f64::EPSILON);
        assert!(result[0].gcd(&result[1]) == 1);
    }
}

fn main () {
    let mut rng = rand::thread_rng();
    for _i in 1..10 {
        let number = rng.gen::<f64>();
        let result = decimal_to_rational(number);
        if result[1] == 1 { println!("{} -> {}", number, result[0]) } else { println!("{} ->  {}/{}", number, result[0], result[1]) }
    }
    for i in [-0.9054054, 0.518518, -0.75, 0.5185185185185185, -0.9054054054054054, 0.0, 1.0, 2.0].iter() {
        let result = decimal_to_rational(*i as f64);
        if result[1] == 1 { println!("{} = {}",*i, result[0]) } else { println!("{} =  {}/{}", *i, result[0], result[1]) }
    }
}

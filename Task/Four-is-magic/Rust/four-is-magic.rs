fn main() {
    magic(4);
    magic(2_340);
    magic(765_000);
    magic(27_000_001);
    magic(999_123_090);
    magic(239_579_832_723_441);
    magic(std::u64::MAX);
}

fn magic(num: u64) {
    if num == 4 {
        println!("four is magic!");
        println!();
        return;
    }
    let name = number_name(num);
    let len = name.len() as u64;
    print!("{} is {}, ", name, number_name(len));
    magic(len);
}


const LOW: &'static [&'static str] = &[
    "zero", "one", "two", "three", "four", "five",
    "six", "seven", "eight","nine", "ten",
    "eleven", "twelve", "thirteen", "fourteen", "fifteen",
    "sixteen", "seventeen", "eighteen", "nineteen"
];
const MED: &'static [&'static str] = &[
    "twenty", "thirty", "forty", "fifty",
    "sixy", "seventy", "eighty", "ninety"
];
const HIGH: &'static [&'static str] = &[
    "thousand", "million", "billion",
    "trillion", "quadrillion", "quintillion"
];

fn number_name(num: u64) -> String {
    if num < 20 {
        return LOW[num as usize].to_string();
    }
    if num < 100 {
        let index = ((num / 10) - 2) as usize;
        let tens = MED[index].to_string();
        let remainder = num % 10;
        if remainder > 0 {
            return format!("{}-{}", tens, number_name(remainder));
        }
        return tens;
    }
    if num < 1000 {
        let hundreds = LOW[(num / 100) as usize];
        let remainder = num % 100;
        if remainder > 0 {
            return format!("{} hundred {}", hundreds, number_name(remainder));
        }
        return format!("{} hundred", hundreds);
    }

    let mut remainder = num % 1000;
    let mut cur = if remainder > 0 { number_name(remainder) } else { "".to_string() };
    let mut n = num / 1000;

    for noun in HIGH.iter() {
        if n > 0 {
            remainder = n % 1000;
            if remainder > 0 {
                // this condition resolves double space issues
                cur =
                    if cur.len() > 0 { format!("{} {} {}", number_name(remainder), noun, cur ) }
                    else { format!("{} {}", number_name(remainder), noun) }
            }
            n /= 1000;
        }
    }
    return cur;
}

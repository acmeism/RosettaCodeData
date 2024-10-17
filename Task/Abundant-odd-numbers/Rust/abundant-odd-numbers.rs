fn divisors(n: u64) -> Vec<u64> {
    let mut divs = vec![1];
    let mut divs2 = Vec::new();

    for i in (2..).take_while(|x| x * x <= n).filter(|x| n % x == 0) {
        divs.push(i);
        let j = n / i;
        if i != j {
            divs2.push(j);
        }
    }
    divs.extend(divs2.iter().rev());

    divs
}

fn sum_string(v: Vec<u64>) -> String {
    v[1..]
        .iter()
        .fold(format!("{}", v[0]), |s, i| format!("{} + {}", s, i))
}

fn abundant_odd(search_from: u64, count_from: u64, count_to: u64, print_one: bool) -> u64 {
    let mut count = count_from;
    for n in (search_from..).step_by(2) {
        let divs = divisors(n);
        let total: u64 = divs.iter().sum();
        if total > n {
            count += 1;
            let s = sum_string(divs);
            if !print_one {
                println!("{}. {} < {} = {}", count, n, s, total);
            } else if count == count_to {
                println!("{} < {} = {}", n, s, total);
            }
        }
        if count == count_to {
            break;
        }
    }
    count_to
}

fn main() {
    let max = 25;
    println!("The first {} abundant odd numbers are:", max);
    let n = abundant_odd(1, 0, max, false);

    println!("The one thousandth abundant odd number is:");
    abundant_odd(n, 25, 1000, true);

    println!("The first abundant odd number above one billion is:");
    abundant_odd(1e9 as u64 + 1, 0, 1, true);
}

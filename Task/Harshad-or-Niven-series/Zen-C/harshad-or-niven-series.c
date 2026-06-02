fn digit_sum(n: int) -> int {
    let sum = 0;
    while n > 0 {
        sum += n % 10;
        n /= 10;
    }
    return sum;
}

fn niven(number: int, minimum: int) {
    println "First {number} Harshad or Niven numbers >= {minimum}:";
    let count = 0;
    for let n = minimum; count < number; ++n {
        if !(n % digit_sum(n)) {
            print "{n} ";
            count++;
        }
    }
    println "";
}

fn main() {
    niven(20, 1);
    println "";
    niven(1, 1001);
}

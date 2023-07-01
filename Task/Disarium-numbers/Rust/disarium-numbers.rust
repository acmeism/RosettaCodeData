fn power(n: i32, exp: i32) -> i32 {
    let mut result = 1;
    for _i in 0..exp {
        result *= n;
    }
    return result;
}

fn is_disarium(num: i32) -> bool {
    let mut n = num;
    let mut sum = 0;
    let mut i = 1;
    let len = num.to_string().len();
    while n > 0 {
        sum += power(n % 10, len as i32 - i + 1);
        n /= 10;
        i += 1
    }
    return sum == num;
}


fn main() {
    let mut i = 0;
    let mut count = 0;
    while count <= 18 {
        if is_disarium(i) {
            print!("{} ", i);
            count += 1;
        }
        i += 1;
    }
    println!("{}", " ")
}

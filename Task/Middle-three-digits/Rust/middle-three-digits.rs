fn middle_three_digits(x: i32) -> Result<String, String> {
    let s: String = x.abs().to_string();
    let len = s.len();
    if len < 3 {
        Err("Too short".into())
    } else if len % 2 == 0 {
        Err("Even number of digits".into())
    } else {
        Ok(s[len/2 - 1 .. len/2 + 2].to_owned())
    }
}

fn print_result(x: i32) {
    print!("middle_three_digits({}) returned: ", x);
    match middle_three_digits(x) {
        Ok(s) => println!("Success, {}", s),
        Err(s) => println!("Failure, {}", s)
    }
}

fn main() {
    let passing = [123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345];
    let failing = [1, 2, -1, -10, 2002, -2002, 0];
    for i in passing.iter() {
        print_result(*i);
    }
    for i in failing.iter() {
        print_result(*i);
    }
}

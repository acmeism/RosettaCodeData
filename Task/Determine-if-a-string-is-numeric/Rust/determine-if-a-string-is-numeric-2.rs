use std::str::FromStr;

fn parsable<T: FromStr>(s: &str) -> bool {
    s.parse::<T>().is_ok()
}

fn main() {
    let test_cases = [
        "142857",
        "3.14",
        "not of this earth!"
    ];

    let types: &[(&str, fn(&str) -> bool)] = &[
        ("i32", parsable::<i32> as fn(&str) -> bool),
        ("i64", parsable::<i32> as fn(&str) -> bool),
        ("i128", parsable::<i32> as fn(&str) -> bool),

        ("f64", parsable::<f64> as fn(&str) -> bool),
    ];

    println!("");
    for &case in &test_cases {
        for &(type_name, parse_fn) in types {
            println!(
                "'{}' {} be parsed as {}",
                case,
                if parse_fn(case) { "can" } else { "_cannot_" },
                type_name
            );
        }
        println!("");
    }
}

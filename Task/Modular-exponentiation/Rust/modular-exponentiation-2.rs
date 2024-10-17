fn main() {
    let (a, b, num_digits) = (
  "2988348162058574136915891421498819466320163312926952423791023078876139",
  "2351399303373464486466122544523690094744975233415544072992656881240319",
  "40",
                    );

    // Covert a, b, and num_digits to numbers:
    let a = BigInt::parse_bytes(a.as_bytes(), 10).unwrap();
    let b = BigInt::parse_bytes(b.as_bytes(), 10).unwrap();
    let num_digits = num_digits.parse().unwrap();

    // Calculate m from num_digits:
    let m = num::pow::pow(10.to_bigint().unwrap(), num_digits);

    // Get the result and print it:
    let result = modular_exponentiation(&a, &b, &m);
    println!("The last {} digits of\n{}\nto the power of\n{}\nare:\n{}",
             num_digits, a, b, result);
}

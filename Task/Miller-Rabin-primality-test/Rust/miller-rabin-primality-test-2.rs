fn main() {
    let n = 1234687;
    let result = is_prime(&n);
    println!("Q: Is {} prime?  A: {}", n, result);

    let n = 1234689;
    let result = is_prime(&n);
    println!("Q: Is {} prime?  A: {}", n, result);

    let n = BigInt::parse_bytes("123123423463".as_bytes(), 10).unwrap();
    let result = is_prime(&n);
    println!("Q: Is {} prime?  A: {}", n, result);

    let n = BigInt::parse_bytes("123123423465".as_bytes(), 10).unwrap();
    let result = is_prime(&n);
    println!("Q: Is {} prime?  A: {}", n, result);

    let n = BigInt::parse_bytes("123123423467".as_bytes(), 10).unwrap();
    let result = is_prime(&n);
    println!("Q: Is {} prime?  A: {}", n, result);

    let n = BigInt::parse_bytes("123123423469".as_bytes(), 10).unwrap();
    let result = is_prime(&n);
    println!("Q: Is {} prime?  A: {}", n, result);
}

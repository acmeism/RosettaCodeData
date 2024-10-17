extern crate luhn_cc;

use luhn_cc::compute_luhn;

fn main() {
    assert_eq!(validate_isin("US0378331005"), true);
    assert_eq!(validate_isin("US0373831005"), false);
    assert_eq!(validate_isin("U50378331005"), false);
    assert_eq!(validate_isin("US03378331005"), false);
    assert_eq!(validate_isin("AU0000XVGZA3"), true);
    assert_eq!(validate_isin("AU0000VXGZA3"), true);
    assert_eq!(validate_isin("FR0000988040"), true);
}

fn validate_isin(isin: &str) -> bool {
    // Preliminary checks to avoid working on non-ASCII stuff
    if !isin.chars().all(|x| x.is_alphanumeric()) || isin.len() != 12 {
        return false;
    }
    if !isin[..2].chars().all(|x| x.is_alphabetic())
        || !isin[2..12].chars().all(|x| x.is_alphanumeric())
        || !isin.chars().last().unwrap().is_numeric()
    {
        return false;
    }

    // Converts the alphanumeric string in a numeric-only string
    let bytes = isin.as_bytes();

    let s2 = bytes.iter()
        .flat_map(|&c| {
            if c.is_ascii_digit() {
                vec![c]
            }
            else {
                (c + 10 - ('A' as u8)).to_string().into_bytes()
            }
        }).collect::<Vec<u8>>();

    let string = std::str::from_utf8(&s2).unwrap();
    let number = string.parse::<usize>().unwrap();

    return compute_luhn(number);
}

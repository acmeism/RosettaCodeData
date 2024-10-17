fn main() {
    for iban in [
        "",
        "x",
        "QQ82",
        "QQ82W",
        "GB82 TEST 1234 5698 7654 322",
        "gb82 WEST 1234 5698 7654 32",
        "GB82 WEST 1234 5698 7654 32",
        "GB82 TEST 1234 5698 7654 32",
        "GB81 WEST 1234 5698 7654 32",
        "SA03 8000 0000 6080 1016 7519",
        "CH93 0076 2011 6238 5295 7",
    ].iter()
    {
        println!(
            "'{}' is {}valid",
            iban,
            if validate_iban(iban) { "" } else { "NOT " }
        );
    }
}

fn validate_iban(iban: &str) -> bool {
    let iso_len = [
        ("AL", 28), ("AD", 24), ("AT", 20), ("AZ", 28), ("BE", 16), ("BH", 22),
        ("BA", 20), ("BR", 29), ("BG", 22), ("HR", 21), ("CY", 28), ("CZ", 24),
        ("DK", 18), ("DO", 28), ("EE", 20), ("FO", 18), ("FI", 18), ("FR", 27),
        ("GE", 22), ("DE", 22), ("GI", 23), ("GL", 18), ("GT", 28), ("HU", 28),
        ("IS", 26), ("IE", 22), ("IL", 23), ("IT", 27), ("KZ", 20), ("KW", 30),
        ("LV", 21), ("LB", 28), ("LI", 21), ("LT", 20), ("LU", 20), ("MK", 19),
        ("MT", 31), ("MR", 27), ("MU", 30), ("MC", 27), ("MD", 24), ("ME", 22),
        ("NL", 18), ("NO", 15), ("PK", 24), ("PS", 29), ("PL", 28), ("PT", 25),
        ("RO", 24), ("SM", 27), ("SA", 24), ("RS", 22), ("SK", 24), ("SI", 19),
        ("ES", 24), ("SE", 24), ("CH", 21), ("TN", 24), ("TR", 26), ("AE", 23),
        ("GB", 22), ("VG", 24), ("GR", 27), ("CR", 21),
    ];
    let trimmed_iban = iban.chars()
        .filter(|&ch| ch != ' ')
        .collect::<String>()
        .to_uppercase();
    if trimmed_iban.len() < 4 {
        return false;
    }
    let prefix = &trimmed_iban[0..2];
    if let Some(pair) = iso_len.iter().find(|&&(code, _)| code == prefix) {
        if pair.1 != trimmed_iban.len() {
            return false;
        }
    } else {
        return false;
    }
    let reversed_iban = format!("{}{}", &trimmed_iban[4..], &trimmed_iban[0..4]);
    let mut expanded_iban = String::new();
    for ch in reversed_iban.chars() {
        expanded_iban.push_str(&if ch.is_numeric() {
            format!("{}", ch)
        } else {
            format!("{}", ch as u8 - 'A' as u8 + 10u8)
        });
    }
    expanded_iban.bytes().fold(0, |acc, ch| {
        (acc * 10 + ch as u32 - '0' as u32) % 97
    }) == 1
}

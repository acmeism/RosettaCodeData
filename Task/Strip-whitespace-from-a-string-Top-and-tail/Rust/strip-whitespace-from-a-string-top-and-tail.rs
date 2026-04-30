fn main() {
    let spaces = " \t\n\x0B\x0C\r \u{A0} \u{2000}\u{3000}";
    let string_with_spaces = spaces.to_owned() + "String without spaces" + spaces;

    assert_eq!(string_with_spaces.trim(), "String without spaces");
    assert_eq!(string_with_spaces.trim_start(), "String without spaces".to_owned() + spaces);
    assert_eq!(string_with_spaces.trim_end(), spaces.to_owned() + "String without spaces");
}

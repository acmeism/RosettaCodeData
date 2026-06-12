let array = [1, 2, 3, 4, 5];
array.iter();
array.chunks(2);
array.windows(3);
array.split_inclusive(|i| i % 5 == 0);

let dict = std::collections::HashMap::from([("key", "value")]);
dict.iter();
dict.keys();
dict.values();

let string = "AsciiКирилица한글👽🦖";
// there are so many ways to iterate over a UTF-8 string that Rust doesn't even bother
// implementing Iterator for just the string
string.chars();
string.bytes();
string.lines();
string.matches(|c| c as u32 & 0x3 == 0);
string.split(char::is_uppercase);

let x = "abc"; // x is of type &str (a borrowed string slice)
let s = String::from(x);
// or alternatively
let s = x.to_owned();

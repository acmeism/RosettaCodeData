const string_literal_str1: &str = "Hi Rust!";

let string_slice_str1: &str = string_literal_str1; // Creating a string slice from a string literal
let string_slice_str2: &str = "hello str"; // String slice pointing to string literal "hello str"

let string1: String = String::new(); // Empty String
let string2: String = String::from("hello"); // Creating String from string literal "hello"
let string3: String = "hi".to_string();
let string4: String = "bye".to_owned();
let string5: String = "see you soon".into();
// The "to_string()", "to_owned" or "into" are all equivalent in the code above.
// The "to_string()", "to_owned" or "into" methods are needed so that a string slice (&str) or a string literal (&str) is explicitly converted into a heap-allocated fully-owned String type. Otherwise the compiler's type checker will complain "expected struct `String`, found `&str` (string slice)"

let string6: String = string_slice_str2.to_owned(); // Explictly converting the string_slice_str2 into a heap-allocated fully-owned String. This can be done with "to_string()", "to_owned" or "into".

// String slices can also point to heap allocated strings:
let string_slice_str3: &str = &string2; // Creating a string slice to a heap-allocated String.
let string7: String = string_slice_str3.to_string(); // Converting string_slice_str3 into a heap-allocated fully-owned String copy, resulting in a new independent owned string copy of the original String. This can be done with "to_string()", "to_owned" or "into".

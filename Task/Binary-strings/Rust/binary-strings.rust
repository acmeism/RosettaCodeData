use std::str;

fn main() {
    // Create new string
    let string = String::from("Hello world!");
    println!("{}", string);
    assert_eq!(string, "Hello world!", "Incorrect string text");

    // Create and assign value to string
    let mut assigned_str = String::new();
    assert_eq!(assigned_str, "", "Incorrect string creation");
    assigned_str += "Text has been assigned!";
    println!("{}", assigned_str);
    assert_eq!(assigned_str, "Text has been assigned!","Incorrect string text");

    // String comparison, compared lexicographically byte-wise same as the asserts above
    if string == "Hello world!" && assigned_str == "Text has been assigned!" {
        println!("Strings are equal");
    }

    // Cloning -> string can still be used after cloning
    let clone_str = string.clone();
    println!("String is:{}  and  Clone string is: {}", string, clone_str);
    assert_eq!(clone_str, string, "Incorrect string creation");

    // Copying, string won't be usable anymore, accessing it will cause compiler failure
    let copy_str = string;
    println!("String copied now: {}", copy_str);

    // Check if string is empty
    let empty_str = String::new();
    assert!(empty_str.is_empty(), "Error, string should be empty");

    // Append byte, Rust strings are a stream of UTF-8 bytes
    let byte_vec = [65]; // contains A
    let byte_str = str::from_utf8(&byte_vec).unwrap();
    assert_eq!(byte_str, "A", "Incorrect byte append");

    // Substrings can be accessed through slices
    let test_str = "Blah String";
    let mut sub_str = &test_str[0..11];
    assert_eq!(sub_str, "Blah String", "Error in slicing");
    sub_str = &test_str[1..5];
    assert_eq!(sub_str, "lah ", "Error in slicing");
    sub_str = &test_str[3..];
    assert_eq!(sub_str, "h String", "Error in slicing");
    sub_str = &test_str[..2];
    assert_eq!(sub_str, "Bl", "Error in slicing");

    // String replace, note string is immutable
    let org_str = "Hello";
    assert_eq!(org_str.replace("l", "a"), "Heaao", "Error in replacement");
    assert_eq!(org_str.replace("ll", "r"), "Hero", "Error in replacement");

    // Joining strings requires a `String` and an &str or a two `String`s one of which needs an & for coercion
    let str1 = "Hi";
    let str2 = " There";
    let fin_str = str1.to_string() + str2;
    assert_eq!(fin_str, "Hi There", "Error in concatenation");

    // Joining strings requires a `String` and an &str or two `Strings`s, one of which needs an & for coercion
    let str1 = "Hi";
    let str2 = " There";
    let fin_str = str1.to_string() + str2;
    assert_eq!(fin_str, "Hi There", "Error in concatenation");

    // Splits -- note Rust supports passing patterns to splits
    let f_str = "Pooja and Sundar are up in Tumkur";
    let split_str: Vec<_> = f_str.split(' ').collect();
    assert_eq!(split_str, ["Pooja", "and", "Sundar", "are", "up", "in", "Tumkur"], "Error in string split");
}

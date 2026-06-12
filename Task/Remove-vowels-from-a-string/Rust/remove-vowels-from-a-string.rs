fn remove_vowels(str: String) -> String {
    let vowels = "aeiouAEIOU";
    let mut devowelled_string = String::from("");

    for i in str.chars() {
        if vowels.contains(i) {
            continue;
        } else {
            devowelled_string.push(i);
        }
    }
    return devowelled_string;
}

fn main() {
    let intro =
        String::from("Ferris, the crab, is the unofficial mascot of the Rust Programming Language");
    println!("{}", intro);
    println!("{}", remove_vowels(intro));
}

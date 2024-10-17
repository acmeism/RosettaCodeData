fn verse(name: &str) -> String {
    let lower_name = name.to_lowercase();
    let mut x = lower_name.clone();
    x.replace_range(0..1, x[0..1].to_uppercase().as_str());
    let y = if "AEIOU".contains(&x[0..=0]) {lower_name.as_str()} else {&x[1..]};
    let b = if &x[0..1] == "B" {""} else {"b"};
    let f = if &x[0..1] == "F" {""} else {"f"};
    let m = if &x[0..1] == "M"{""} else {"m"};
    return format!(r#"
    {x}, {x}, bo-{b}{y}
    Banana-fana fo-{f}{y}
    Fee-fi-mo-{m}{y}
    {x}!"#);
}

fn main() {
    for name in ["gARY", "Earl", "Billy", "Felix", "Mary", "sHIRley"] {
        println!("{}", verse(name));
    }
}

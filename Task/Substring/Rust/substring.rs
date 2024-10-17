let s = "abc文字化けdef";
let n = 2;
let m = 3;

    // Print 3 characters starting at index 2 (c文字)
println!("{}", s.chars().skip(n).take(m).collect::<String>());

    // Print all characters starting at index 2 (c文字化けdef)
println!("{}", s.chars().skip(n).collect::<String>());

    // Print all characters except the last (abc文字化けde)
println!("{}", s.chars().rev().skip(1).collect::<String>());

    // Print 3 characters starting with 'b' (bc文)
let cpos = s.find('b').unwrap();
println!("{}", s[cpos..].chars().take(m).collect::<String>());

    // Print 3 characters starting with "けd" (けde)
let spos = s.find("けd").unwrap();
println!("{}", s[spos..].chars().take(m).collect::<String>());

fn main() {
    let xs = (1..=12)
        .map(|a| {
            (1..=12)
                .map(|b| {
                    if a > b {
                        String::from("    ")
                    } else {
                        format!("{:4}", a * b)
                    }
                })
                .collect::<String>()
        })
        .collect::<Vec<String>>();

    println!("{}", xs.join("\n"))
}

fn main() {
    let items: [(&str, f32, u8); 9] = [
        ("beef", 3.8, 36),
        ("pork", 5.4, 43),
        ("ham", 3.6, 90),
        ("greaves", 2.4, 45),
        ("flitch", 4.0, 30),
        ("brawn", 2.5, 56),
        ("welt", 3.7, 67),
        ("salami", 3.0, 95),
        ("sausage", 5.9, 98),
    ];
    let mut weight: f32 = 15.0;
    let mut values: Vec<(&str, f32, f32)> = Vec::new();
    for item in &items {
        values.push((item.0, f32::from(item.2) / item.1, item.1));
    }

    values.sort_by(|a, b| (a.1).partial_cmp(&b.1).unwrap());
    values.reverse();

    for choice in values {
        if choice.2 <= weight {
            println!("Grab {:.1} kgs of {}", choice.2, choice.0);
            weight -= choice.2;
            if (choice.2 - weight).abs() < std::f32::EPSILON {
                return;
            }
        } else {
            println!("Grab {:.1} kgs of {}", weight, choice.0);
            return;
        }
    }
}

fn padovan_recur() -> impl std::iter::Iterator<Item = usize> {
    let mut p = vec![1, 1, 1];
    let mut n = 0;
    std::iter::from_fn(move || {
        let pn = if n < 3 { p[n] } else { p[0] + p[1] };
        p[0] = p[1];
        p[1] = p[2];
        p[2] = pn;
        n += 1;
        Some(pn)
    })
}

fn padovan_floor() -> impl std::iter::Iterator<Item = usize> {
    const P: f64 = 1.324717957244746025960908854;
    const S: f64 = 1.0453567932525329623;
    (0..).map(|x| (P.powf((x - 1) as f64) / S + 0.5).floor() as usize)
}

fn padovan_lsystem() -> impl std::iter::Iterator<Item = String> {
    let mut str = String::from("A");
    std::iter::from_fn(move || {
        let result = str.clone();
        let mut next = String::new();
        for ch in str.chars() {
            match ch {
                'A' => next.push('B'),
                'B' => next.push('C'),
                _ => next.push_str("AB"),
            }
        }
        str = next;
        Some(result)
    })
}

fn main() {
    println!("First 20 terms of the Padovan sequence:");
    for p in padovan_recur().take(20) {
        print!("{} ", p);
    }
    println!();

    println!(
        "\nRecurrence and floor functions agree for first 64 terms? {}",
        padovan_recur().take(64).eq(padovan_floor().take(64))
    );

    println!("\nFirst 10 strings produced from the L-system:");
    for p in padovan_lsystem().take(10) {
        print!("{} ", p);
    }
    println!();

    println!(
        "\nLength of first 32 strings produced from the L-system = Padovan sequence? {}",
        padovan_lsystem()
            .map(|x| x.len())
            .take(32)
            .eq(padovan_recur().take(32))
    );
}

fn expand(cp: &str) -> String {
    let mut out = String::new();
    for c in cp.chars() {
        out.push_str(match c {
            'N' => "north",
            'E' => "east",
            'S' => "south",
            'W' => "west",
            'b' => " by ",
            _ => "-",
        });
    }
    out
}

fn main() {
    let cp = [
        "N", "NbE", "N-NE", "NEbN", "NE", "NEbE", "E-NE", "EbN",
        "E", "EbS", "E-SE", "SEbE", "SE", "SEbS", "S-SE", "SbE",
        "S", "SbW", "S-SW", "SWbS", "SW", "SWbW", "W-SW", "WbS",
        "W", "WbN", "W-NW", "NWbW", "NW", "NWbN", "N-NW", "NbW"
    ];
    println!("Index  Degrees  Compass point");
    println!("-----  -------  -------------");
    for i in 0..=32 {
        let index = i % 32;
        let heading = i as f32 * 11.25
            + match i % 3 {
                1 => 5.62,
                2 => -5.62,
                _ => 0.0,
            };
        println!(
            "{:2}     {:6.2}   {}",
            index + 1,
            heading,
            expand(cp[index])
        );
    }
}

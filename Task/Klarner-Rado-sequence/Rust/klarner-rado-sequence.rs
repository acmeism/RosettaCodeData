fn main() {
    let limit = 1_000_000;
    let klarner_rado = initialise_klarner_rado_sequence(limit);

    println!("The first 100 elements of the Klarner-Rado sequence:");
    for i in 1..=100 {
        print!("{:3}", klarner_rado[i]);
        if i % 10 == 0 {
            println!();
        } else {
            print!(" ");
        }
    }
    println!();

    let mut index = 1_000;
    while index <= limit {
        println!("The {}th element of Klarner-Rado sequence is {}", index, klarner_rado[index]);
        index *= 10;
    }
}

fn initialise_klarner_rado_sequence(limit: usize) -> Vec<usize> {
    let mut result = vec![0; limit + 1];
    let mut i2 = 1;
    let mut i3 = 1;
    let mut m2 = 1;
    let mut m3 = 1;

    for i in 1..=limit {
        let minimum = std::cmp::min(m2, m3);
        result[i] = minimum;
        if m2 == minimum {
            m2 = result[i2] * 2 + 1;
            i2 += 1;
        }
        if m3 == minimum {
            m3 = result[i3] * 3 + 1;
            i3 += 1;
        }
    }
    result
}

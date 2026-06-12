fn seq(len: usize) -> Vec<usize> {
    let mut ruler = vec![];

    for i in 1.. {
        let mut intervals = (0..ruler.len()).flat_map(|size| ruler.windows(size + 1));

        if intervals.any(|window| i == window.iter().sum()) {
            continue;
        } else {
            ruler.push(i);
        }

        if ruler.len() == len {
            break;
        }
    }

    ruler
}

fn main() {
    let len = if cfg!(feature = "stretch_goal") {
        1000
    } else {
        100
    };
    let s = seq(len);

    println!("First 100:");

    for row in s.chunks(10).take(10) {
        for col in row {
            print!("{col:>3} ");
        }
        println!();
    }

    #[cfg(feature = "stretch_goal")]
    println!("\nOne Thousandth: {}", s[999]);
}

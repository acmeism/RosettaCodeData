use std::collections::BinaryHeap;

fn a094958_iter() -> Vec<u16> {
    (0..12)
        .map(|n| vec![1 << n, 5 * (1 << n)])
        .flatten()
        .filter(|x| x < &2200)
        .collect::<BinaryHeap<u16>>()
        .into_sorted_vec()
}

fn a094958_filter() -> Vec<u16> {
    (1..2200) // ported from Sidef
        .filter(|n| ((n & (n - 1) == 0) || (n % 5 == 0 && ((n / 5) & (n / 5 - 1) == 0))))
        .collect()
}

fn a094958_loop() -> Vec<u16> {
    let mut v = vec![];
    for n in 0..12 {
        v.push(1 << n);
        if 5 * (1 << n) < 2200 {
            v.push(5 * (1 << n));
        }
    }
    v.sort();
    return v;
}

fn main() {
    println!("{:?}", a094958_iter());
    println!("{:?}", a094958_loop());
    println!("{:?}", a094958_filter());
}

#[cfg(test)]
mod tests {
    use super::*;
    static HAPPY: &str = "[1, 2, 4, 5, 8, 10, 16, 20, 32, 40, 64, 80, 128, 160, 256, 320, 512, 640, 1024, 1280, 2048]";
    #[test]
    fn test_a094958_iter() {
        assert!(format!("{:?}", a094958_iter()) == HAPPY);
    }
    #[test]
    fn test_a094958_loop() {
        assert!(format!("{:?}", a094958_loop()) == HAPPY);
    }
    #[test]
    fn test_a094958_filter() {
        assert!(format!("{:?}", a094958_filter()) == HAPPY);
    }
}

const ONE: &str = "●";
const FIVE: &str = "——";
const ZERO: &str = "Θ";

fn main() {
    println!("{}", mayan(4005));
    println!("{}", mayan(8017));
    println!("{}", mayan(326_205));
    println!("{}", mayan(886_205));
    println!("{}", mayan(69));
    println!("{}", mayan(420));
    println!("{}", mayan(1_063_715_456));
}

fn mayan(dec: i64) -> String {
    let mut digits = vec![];
    let mut num = dec;
    while num > 0 {
        digits.push(num % 20);
        num /= 20;
    }
    digits = digits.into_iter().rev().collect();
    let mut boxes = vec!["".to_string(); 6];
    let n = digits.len();
    for (i, digit) in digits.iter().enumerate() {
        if i == 0 {
            boxes[0] = "┏━━━━".to_string();
            if i == n - 1 {
                boxes[0] += "┓";
            }
        } else if i == n - 1 {
            boxes[0] += "┳━━━━┓";
        } else {
            boxes[0] += "┳━━━━";
        }
        for j in 1..5 {
            boxes[j] += "┃";
            let elem = 0.max(digit - (4 - j as i64) * 5);
            if elem >= 5 {
                boxes[j] += &format!("{: ^4}", FIVE);
            } else if elem > 0 {
                boxes[j] += &format!("{: ^4}", ONE.repeat(elem as usize % 15));
            } else if j == 4 {
                boxes[j] += &format!("{: ^4}", ZERO);
            } else {
                boxes[j] += &"    ";
            }
            if i == n - 1 {
                boxes[j] += "┃";
            }
        }
        if i == 0 {
            boxes[5] = "┗━━━━".to_string();
            if i == n - 1 {
                boxes[5] += "┛";
            }
        } else if i == n - 1 {
            boxes[5] += "┻━━━━┛";
        } else {
            boxes[5] += "┻━━━━";
        }
    }

    let mut mayan = format!("Mayan {}:\n", dec);
    for b in boxes {
        mayan += &(b + "\n");
    }
    mayan
}

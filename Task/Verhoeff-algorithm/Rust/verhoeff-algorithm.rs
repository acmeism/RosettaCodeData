const MULTIPLICATION_TABLE: [[i32; 10]; 10] = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
    [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
    [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
    [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
    [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
    [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
    [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
    [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
    [9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
];

const INVERSE: [i32; 10] = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9];

const PERMUTATION_TABLE: [[i32; 10]; 8] = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
    [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
    [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
    [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
    [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
    [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
    [7, 0, 4, 6, 9, 1, 3, 2, 5, 8],
];

fn verhoeff_checksum(number: &str, do_validation: bool, do_display: bool) -> i32 {
    if do_display {
        let calculation_type = if do_validation {
            "Validation"
        } else {
            "Check digit"
        };
        println!("{} calculations for {}\n", calculation_type, number);
        println!(" i  ni  p[i, ni]  c");
        println!("-------------------");
    }

    let mut working_number = String::from(number);
    if !do_validation {
        working_number.push('0');
    }

    let mut c = 0;
    let le = working_number.len() - 1;
    let chars: Vec<char> = working_number.chars().collect();

    for i in (0..=le).rev() {
        let ni = chars[i].to_digit(10).unwrap() as i32;
        let pos = (le - i) % 8;
        let pi = PERMUTATION_TABLE[pos][ni as usize];
        c = MULTIPLICATION_TABLE[c as usize][pi as usize];

        if do_display {
            println!(
                "{:2}  {:2}       {:2}     {:2}\n",
                le - i,
                ni,
                pi,
                c
            );
        }
    }

    if do_display && !do_validation {
        println!("inverse[{}] = {}\n", c, INVERSE[c as usize]);
    }

    if do_validation {
        if c == 0 { 1 } else { 0 }
    } else {
        INVERSE[c as usize]
    }
}

fn main() {
    let tests = [
        ("123", true),
        ("12345", true),
        ("123456789012", false),
    ];

    for &(test_num, display) in tests.iter() {
        let digit = verhoeff_checksum(test_num, false, display);
        println!("The check digit for {} is {}\n", test_num, digit);

        let numbers = [
            format!("{}{}", test_num, digit),
            format!("{}9", test_num),
        ];

        for number in numbers.iter() {
            let digit = verhoeff_checksum(number, true, display);
            let result = if digit == 1 { "correct" } else { "incorrect" };
            println!("The validation for {:?} is {:?}. ", number, result);
        }
    }
}

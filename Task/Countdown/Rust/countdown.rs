use rand::seq::SliceRandom;
use rand::thread_rng;
use rand::Rng;

fn main() {
    let mut all_numbers = vec![
        1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 25, 50, 75, 100
    ];

    let mut rng = thread_rng();
    all_numbers.shuffle(&mut rng);

    let number_lists = vec![
        vec![3, 6, 25, 50, 75, 100],
        vec![100, 75, 50, 25, 6, 3],
        vec![8, 4, 4, 6, 8, 9],
        all_numbers[0..6].to_vec(),
    ];

    let target_list = vec![952, 952, 594, rng.gen_range(101..1000)];

    for i in 0..target_list.len() {
        println!("Using : {:?}", number_lists[i]);
        println!("Target: {}", target_list[i]);
        let done = countdown(&number_lists[i], target_list[i]);
        if !done {
            println!("No solution found");
        }
        println!();
    }
}

fn countdown(numbers: &[i32], target: i32) -> bool {
    if numbers.len() <= 1 {
        return false;
    }

    for (i, &n0) in numbers.iter().enumerate() {
        let mut numbers1 = Vec::new();
        numbers1.extend_from_slice(&numbers[..i]);
        numbers1.extend_from_slice(&numbers[i + 1..]);

        for (j, &n1) in numbers1.iter().enumerate() {
            let mut numbers2 = Vec::new();
            numbers2.extend_from_slice(&numbers1[..j]);
            numbers2.extend_from_slice(&numbers1[j + 1..]);

            if n1 >= n0 {
                // Addition
                let result = n1 + n0;
                let mut numbers_next = numbers2.clone();
                numbers_next.push(result);
                if result == target || countdown(&numbers_next, target) {
                    println!("{} = {} + {}", result, n1, n0);
                    return true;
                }

                // Multiplication
                if n0 != 1 {
                    let result = n1 * n0;
                    let mut numbers_next = numbers2.clone();
                    numbers_next.push(result);
                    if result == target || countdown(&numbers_next, target) {
                        println!("{} = {} * {}", result, n1, n0);
                        return true;
                    }
                }

                // Subtraction
                if n1 != n0 {
                    let result = n1 - n0;
                    let mut numbers_next = numbers2.clone();
                    numbers_next.push(result);
                    if result == target || countdown(&numbers_next, target) {
                        println!("{} = {} - {}", result, n1, n0);
                        return true;
                    }
                }

                // Division
                if n0 != 1 && n1 % n0 == 0 {
                    let result = n1 / n0;
                    let mut numbers_next = numbers2.clone();
                    numbers_next.push(result);
                    if result == target || countdown(&numbers_next, target) {
                        println!("{} = {} / {}", result, n1, n0);
                        return true;
                    }
                }
            }
        }
    }
    false
}

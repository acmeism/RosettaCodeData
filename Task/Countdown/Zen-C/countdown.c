import "std/random.zc"
import "std/vec.zc"

let rng: Random;

fn shuffle(a: int*, len: usize) {
    for let i: usize = len - 1; i >= 1; --i {
        let j = rng.next_int_range(0, (int)i);
        if j != i {
            let t = a[i];
            a[i] = a[j];
            a[j] = t;
        }
    }
}

fn countdown(numbers: Vec<int>, target: int) -> bool {
    if numbers.length() <= 1 { return false; }
    for i in 0..numbers.length() {
        let n0 = numbers.get(i);
        let numbers1 = Vec<int>::new();
        for k in 0..numbers.length() {
            if k != i { numbers1 << numbers.get(k); }
        }
        for j in 0..numbers1.length() {
            let n1 = numbers1.get(j);
            let numbers2 = Vec<int>::new();
            for k in 0..numbers1.length() {
                if k != j { numbers2 << numbers1.get(k); }
            }
            if n1 >= n0 {
                // Addition.
                let result = n1 + n0;
                let numbers_new = numbers2.clone();
                numbers_new << result;
                if result == target || countdown(numbers_new, target) {
                    println "{result} = {n1} + {n0}";
                    return true;
                }
                // Multiplication.
                if n0 != 1 {
                    result = n1 * n0;
                    let numbers_next = numbers2.clone();
                    numbers_next << result;
                    if result == target || countdown(numbers_next, target) {
                        println "{result} = {n1} * {n0}";
                        return true;
                    }
                }
                // Subtraction.
                if n1 != n0 {
                    result = n1 - n0;
                    let numbers_next = numbers2.clone();
                    numbers_next << result;
                    if result == target || countdown(numbers_next, target) {
                        println "{result} = {n1} - {n0}";
                        return true;
                    }
                }
                // Division.
                if n0 != 1  && !(n1 % n0) {
                    result = n1 / n0;
                    let numbers_next = numbers2.clone();
                    numbers_next << result;
                    if result == target || countdown(numbers_next, target) {
                        println "{result} = {n1} / {n0}";
                        return true;
                    }
                }
            }
        }
    }
    return false;
}

fn main() {
    rng = Random::new();
    let all_numbers = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 25, 50, 75, 100];
    shuffle(all_numbers, all_numbers.len);
    let a1 = [3, 6, 25, 50, 75, 100];
    let a2 = [100, 75, 50, 25, 6, 3]; // see if there's much difference if we reverse a1
    let a3 = [8, 4, 4, 6, 8, 9];
    let a4: int[6];
    for i in 0..6 { a4[i] = all_numbers[i]; }
    let aa: int*[4] = [a1, a2, a3, a4];
    let target_list = [952, 952, 594, rng.next_int_range(101, 999)];
    for i in 0..4 {
        let v = Vec<int>::new();
        print "Using : [";
        for j in 0..6 {
            print "{aa[i][j]}, ";
            v << aa[i][j];
        }
        println "\b\b]";
        println "Target: {target_list[i]}";
        let done = countdown(v, target_list[i]);
        if !done { println "No exact solution found."; }
        println "";
    }
}

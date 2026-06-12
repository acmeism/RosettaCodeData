import "std/vec.zc"
import "locale.h"

let diffs: const int[8] = [-7, -5, -3, -2, 2, 3, 5, 7];
let possibles: [Vec<int>; 10];

fn main() {
    for i in 0..10 {
        possibles[i] = Vec<int>::new();
        for d in diffs {
            let sum = i + d;
            if sum >= 0 && sum < 10 { possibles[i] << sum; }
        }
    }
    let places = 10;
    let start = 1;
    let strange_ones = Vec<int>::new();
    strange_ones << start;
    for i in 2..=places {
        let new_ones = Vec<int>::new();
        for n in strange_ones {
            for next_n in possibles[n % 10] { new_ones << (n * 10 + next_n); }
        }
        strange_ones.free();
        strange_ones = new_ones;
    }
    setlocale(LC_NUMERIC, "");
    println "Found {strange_ones.length():'lu} {places}-digit strange numbers beginning with {start}.";
    for i in 0..10 { possibles[i].free(); }
}

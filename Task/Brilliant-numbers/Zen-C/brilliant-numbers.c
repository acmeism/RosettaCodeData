import "std/math.zc"
import "std/vec.zc"
import "std/sort.zc"
import "locale.h"

fn prime_sieve(n: int) -> Vec<int> {
    let primes = Vec<int>::new();
    if n < 2 { return primes; }
    primes << 2;
    if n == 2 { return primes; }
    let k = (n - 3) / 2 + 1;
    autofree let marked = (bool*)malloc(k * sizeof(bool));
    for i in 0..k { marked[i] = true; }
    let limit = ((int)Math::sqrt((f64)n) - 3) / 2 + 1;
    if limit < 0 { limit = 0; }
    for i in 0..limit {
        if marked[i] {
            let p = 2 * i + 3;
            let s = (p * p - 3) / 2;
            while s < k {
                marked[s] = false;
                s += p;
            }
        }
    }
    for i in 0..k {
        if marked[i] { primes << (2 * i + 3); }
    }
    return primes;
}

let all_primes: Vec<int>;

def MAX_U64 = 18_446_744_073_709_551_615;

fn get_brilliant(digits: int, limit: u64, count_only: bool) -> Vec<u64> {
    let brilliant = Vec<u64>::new();
    let count: u64 = 0;
    let pow: u64 = 1;
    let next: u64 = MAX_U64;
    let start_ix = 0;
    for _ in 1..=digits {
        let s = Vec<u64>::new();
        let len = all_primes.length();
        for let i = start_ix; i < len; ++i {
            if all_primes[i] > pow * 10 {
                start_ix = i;
                break;
            }
            s << all_primes[i];
        }
        for i in 0..s.length() {
            for j in i..s.length() {
                let prod: u64 = s[i] * s[j];
                if prod < limit {
                    if count_only {
                        count++;
                    } else {
                        brilliant << prod;
                    }
                } else {
                    if prod < next { next = prod; }
                    break;
                }
            }
        }
        pow *= 10;
    }
    if count_only {
        brilliant << count;
        brilliant << next;
    }
    return brilliant;
}

fn ord(n: u64, ch: char[3]) {
    let m = n % 100;
    if m >= 4 && m <= 20 {
        strcpy(ch, "th");
        return;
    }
    m %= 10;
    let s: string;
    match (m) {
        1 => { s = "st"; }
        2 => { s = "nd"; }
        3 => { s = "rd"; }
        _ => { s = "th"; }
    }
    strcpy(ch, s);
}

fn main() {
    all_primes = prime_sieve(99_999_999);
    println "First 100 brilliant numbers:";
    let brilliant = get_brilliant(2, 10000, false);
    sort_long(brilliant.data, brilliant.len);
    for i in 0..100 {
        print "{brilliant[i]:4lu} ";
        if !((i + 1) % 10) { println ""; }
    }
    println "";
    setlocale(LC_NUMERIC, "");
    let limit: u64 = 1
    let ch: [char; 3];
    for k in 1..=13 {
        limit *= 10;
        let res = get_brilliant(k, limit, true);
        let count = res[0] + 1;
        let next = res[1];
        ord(count, ch);
        println "First >= {limit:'18lu} is {count:'14lu}{ch} in the series: {next:'18lu}";
    }
    all_primes.free();
}

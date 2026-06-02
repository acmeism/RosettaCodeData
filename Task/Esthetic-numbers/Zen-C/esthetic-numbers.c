import "std/vec.zc"
import "std/string.zc"
import "locale.h"

fn uabs(a: u64, b: u64) -> u64 { return a > b ? a - b : b - a; }

fn is_esthetic(n: u64, b: u64) -> bool {
    if n == 0 { return false; }
    let i = n % b;
    n /= b;
    while n > 0 {
        let j = n % b;
        if uabs(i, j) != 1 { return false; }
        n /= b;
        i = j;
    }
    return true;
}

let esths: Vec<u64>;

fn dfs(n: u64, m: u64, i: u64) {
    if i >= n && i <= m { esths << i; }
    if i == 0 || i > m { return; }
    let d = i % 10;
    let i1 = i * 10 + d - 1;
    let i2 = i1 + 2;
    if d == 0 {
        dfs(n, m, i2);
    } else if d == 9 {
        dfs(n, m, i1);
    } else {
        dfs(n, m, i1);
        dfs(n, m, i2);
    }
}

fn list_esths(n: u64, n2: u64, m: u64, m2: u64, per_line: int, all: bool) {
    esths.clear();
    for let i: u64 = 0; i < 10; ++i { dfs(n2, m2, i); }
    let le = esths.length();
    println "Base 10: {le:'lu} esthetic numbers between {n:'lu} and {m:'lu:}";
    if all {
        for c, esth in esths {
            print "{esth} ";
            if (c + 1) % per_line == 0 { println ""; }
        }
    } else {
        for i in 0..per_line { print "{esths[i]:lu} "; }
        println "\n............\n";
        for i in (le - per_line)..le { print "{esths[i]:lu} "; }
    }
    println "\n";
}

def DIGITS = "0123456789abcdefghijklmnopqrstuvwxyz";

fn itoa(n: u64, b: u64) -> String {
    assert(b >= 2 && b <= 36, "Base must be between 2 and 36.");
    if n == 0 { return String::from("0"); }
    let vr = Vec<rune>::new();
    while n > 0 {
        vr << DIGITS[n % b];
        n /= b;
    }
    vr.reverse();
    return String::from_runes_vec(vr);
}

fn main() {
    esths = Vec<u64>::new();
    setlocale(LC_NUMERIC, "");
    for let b: u64 = 2; b <= 16; ++b {
        println "Base {b}: {4 * b}th to {6 * b}th esthetic numbers:";
        let c: u64 = 0;
        for let n: u64 = 1; c < 6 * b; ++n {
            if is_esthetic(n, b) {
                c++;
                if c >= 4 * b { print "{itoa(n, b)} "; }
            }
        }
        println "\n";
    }
    list_esths(1000, 1010, 9999, 9898, 16, true);
    list_esths((u64)1e8, 101_010_101, 13 * (u64)1e7, 123_456_789, 9, true);
    list_esths((u64)1e11, 101_010_101_010, 13 * (u64)1e10, 123_456_789_898, 7, false);
    list_esths((u64)1e14, 101_010_101_010_101, 13 * (u64)1e13, 123_456_789_898_989, 5, false);
    list_esths((u64)1e17, 101_010_101_010_101_010, 13 * (u64)1e16, 123_456_789_898_989_898, 4, false);
    esths.free();
}

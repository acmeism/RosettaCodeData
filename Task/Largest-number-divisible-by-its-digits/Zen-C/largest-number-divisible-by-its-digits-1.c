import "std/set.zc"

fn are_digits_distinct(s: string) -> bool {
    let set = Set<int>::new();
    let len = strlen(s);
    for i in 0..len { set.add(s[i]); }
    return len == set.length();
}

fn is_div_by_all(n: int, s: string) -> bool {
    for i in 0..strlen(s) {
        if n % (s[i] - 48) { return false; }
    }
    return true;
}

fn main() {
    def MAGIC = 9 * 8 * 7;
    def HIGH  = 9876432 / MAGIC * MAGIC;
    for (let i = HIGH; i >= MAGIC; i -= MAGIC) {
        if !(i % 10) { continue; }  // can't end in '0'
        let s = "{i}";
        if strchr(s, '0') || strchr(s, '5') { // can't contain '0' or '5'
            continue;
        }
        if !are_digits_distinct(s) { continue; } // digits must be unique
        if is_div_by_all(i, s) {
            println "Largest decimal number is {i}.";
            break;
        }
    }
}

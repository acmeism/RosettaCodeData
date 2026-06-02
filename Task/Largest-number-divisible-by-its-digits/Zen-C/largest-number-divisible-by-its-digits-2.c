import "std/set.zc"

fn are_digits_distinct(s: string) -> bool {
    let set = Set<int>::new();
    let len = strlen(s);
    for i in 0..len { set.add(s[i]); }
    return len == set.length();
}

fn is_div_by_all(n: u64, s: string) -> bool {
    for i in 0..strlen(s) {
        let d: u64 = (s[i] <= '9') ? s[i] - '0' : s[i] - 'W'
        if n % d { return false; }
    }
    return true;
}

fn main() {
    def MAGIC: u64 = 15 * 14 * 13 * 12 * 11;
    def HIGH : u64 = (u64)0xfedcba987654321 / MAGIC * MAGIC;
    for (let i = HIGH; i >= MAGIC; i -= MAGIC) {
        if !(i % 16) { continue; }               // can't end in '0'
        let s = "{i:lx}";                        // always generates lower case a-f
        if strchr(s, '0') { continue; }          // can't contain '0'
        if !are_digits_distinct(s) { continue; } // digits must be unique
        if is_div_by_all(i, s) {
            println "Largest hex number is {i:lx}.";
            break;
        }
    }
}

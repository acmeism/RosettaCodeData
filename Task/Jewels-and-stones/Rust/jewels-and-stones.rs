fn count_jewels(stones: &str, jewels: &str) -> u8 {
    let mut count: u8 = 0;
    for cur_char in stones.chars() {
        if jewels.contains(cur_char) {
            count += 1;
        }
    }
    count
}
fn main() {
    println!("{}", count_jewels("aAAbbbb", "aA"));
    println!("{}", count_jewels("ZZ", "z"));
}

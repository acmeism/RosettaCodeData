fn count_jewels(stones: string, jewels: string) -> int {
    let count = 0;
    for i in 0..strlen(stones) {
        for j in 0..strlen(jewels) {
            if stones[i] == jewels[j] { count++; break; }
        }
    }
    return count;
}

fn main() {
    let stones = "aAAbbbb";
    let jewels = "aA";
    println "{count_jewels(stones, jewels)}";
}

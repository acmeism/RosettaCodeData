fn js(stones string, jewels string) int {
	mut n := 0
    for b in stones.bytes() {
        if jewels.index_u8(b) >= 0 {
            n++
        }
    }
    return n
}

fn main() {
    println(js("aAAbbbb", "aA"))
}

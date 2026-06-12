fn wordle(answer string, guess string) []int {
    n := guess.len
    if n != answer.len {
        println("The words must be of the same length.")
    }
    mut answer_bytes := answer.bytes()
    mut result := []int{len:n} // all zero by default
    for i := 0; i < n; i++ {
        if guess[i] == answer_bytes[i] {
            answer_bytes[i] = u8(000)
            result[i] = 2
        }
    }
    for i := 0; i < n; i++ {
        ix := answer_bytes.index(guess[i])
        if ix >= 0 {
            answer_bytes[ix] = u8(000)
            result[i] = 1
        }
    }
    return result
}

fn main() {
    colors := ["grey", "yellow", "green"]
    pairs := [
        ["ALLOW", "LOLLY"],
        ["BULLY", "LOLLY"],
        ["ROBIN", "ALERT"],
        ["ROBIN", "SONIC"],
        ["ROBIN", "ROBIN"],
    ]
    for pair in pairs {
        res := wordle(pair[0], pair[1])
        mut res2 := []string{len: res.len}
        for i := 0; i < res.len; i++ {
            res2[i] = colors[res[i]]
        }
        println("${pair[0]} v ${pair[1]} => $res => $res2\n")
    }
}

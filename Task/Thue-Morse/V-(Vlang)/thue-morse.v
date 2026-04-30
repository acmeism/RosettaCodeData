fn thue_morse(previous string) string {
    mut tm := ""
    for ch in previous {
        if ch == `1` { tm += "0" } else { tm += "1" }
    }
    println("")
    return previous + tm
}

fn main() {
    mut tm := "0"
    print(tm)
    for _ in 1 .. 7 {
        tm = thue_morse(tm)
        print(tm)
    }
    println("")
}

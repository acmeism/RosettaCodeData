fn main() {
    mut n := [
        "---------- Ice and Fire ------------",
        "                                    ",
        "fire, in end will world the say Some",
        "ice. in say Some                    ",
        "desire of tasted I've what From     ",
        "fire. favor who those with hold I   ",
        "                                    ",
        "... elided paragraph last ...       ",
        "                                    ",
        "Frost Robert -----------------------",
    ]
    for i, s in n {
        mut t := s.fields() // tokenize
        // reverse
        last := t.len - 1
        for j, k in t[..t.len/2] {
            t[j], t[last-j] = t[last-j], k
        }
        n[i] = t.join(" ")
    }
    // display result
    for t in n {
        println(t)
    }
}

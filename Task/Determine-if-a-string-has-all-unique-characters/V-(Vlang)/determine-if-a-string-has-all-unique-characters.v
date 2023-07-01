fn analyze(s string) {
    chars := s.runes()
    le := chars.len
    println("Analyzing $s which has a length of $le:")
    if le > 1 {
        for i := 0; i < le-1; i++ {
            for j := i + 1; j < le; j++ {
                if chars[j] == chars[i] {
                    println("  Not all characters in the string are unique.")
                    println("  '${chars[i]}'' (0x${chars[i]:x}) is duplicated at positions ${i+1} and ${j+1}.\n")
                    return
                }
            }
        }
    }
    println("  All characters in the string are unique.\n")
}

fn main() {
    strings := [
        "",
        ".",
        "abcABC",
        "XYZ ZYX",
        "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ",
        "01234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ0X",
        "hétérogénéité",
        "🎆🎃🎇🎈",
        "😍😀🙌💃😍🙌",
        "🐠🐟🐡🦈🐬🐳🐋🐡",
    ]
    for s in strings {
        analyze(s)
    }
}

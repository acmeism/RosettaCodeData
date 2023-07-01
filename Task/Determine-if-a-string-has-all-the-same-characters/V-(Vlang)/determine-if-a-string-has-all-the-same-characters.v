fn analyze(s string) {
    chars := s.runes()
    le := chars.len
    println("Analyzing $s which has a length of $le:")
    if le > 1 {
        for i in 1..le{
            if chars[i] != chars[i-1] {
                println("  Not all characters in the string are the same.")
                println("  '${chars[i]}' (0x${chars[i]:x}) is different at position ${i+1}.\n")
                return
            }
        }
    }
    println("  All characters in the string are the same.\n")
}

fn main() {
    strings := [
        "",
        "   ",
        "2",
        "333",
        ".55",
        "tttTTT",
        "4444 444k",
        "pépé",
        "🐶🐶🐺🐶",
        "🎄🎄🎄🎄"
	]
    for s in strings {
        analyze(s)
    }
}

// Returns squeezed string, original and new lengths in
// unicode code points (not normalized).
fn squeeze(s string, c string) (string, int, int) {
    mut r := s.runes()
    mut t := c.runes()[0]
    le, mut del := r.len, 0
    for i := le - 2; i >= 0; i-- {
        if r[i] == t && r[i] == r[i+1] {
            r.delete(i)
            del++
        }
    }
    if del == 0 {
        return s, le, le
    }
    r = r[..le-del]
    return r.string(), le, r.len
}

fn main() {
    strings := [
        "",
        '"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln ',
        "..1111111111111111111111111111111111111111111111111111111111111117777888",
        "I never give 'em hell, I just tell the truth, and they think it's hell. ",
        "                                                   ---  Harry S Truman  ",
        "The better the 4-wheel drive, the further you'll be from help when ya get stuck!",
        "headmistressship",
        "aardvark",
        "😍😀🙌💃😍😍😍🙌",
	]
    chars := [[' '], ['-'], ['7'], ['.'], [' ', '-', 'r'], ['e'], ['s'], ['a'], ['😍']]

    for i, s in strings {
        for c in chars[i] {
            ss, olen, slen := squeeze(s, c)
            println("specified character = $c")
            println("original : length = ${olen:2}, string = «««$s»»»")
            println("squeezed : length = ${slen:2}, string = «««$ss»»»\n")
        }
    }
}

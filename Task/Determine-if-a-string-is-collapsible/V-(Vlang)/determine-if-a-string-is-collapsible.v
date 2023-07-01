// Returns collapsed string, original and new lengths in
// unicode code points (not normalized).
fn collapse(s string) (string, int, int) {
    mut r := s.runes()
    le, mut del := r.len, 0
    for i := le - 2; i >= 0; i-- {
        if r[i] == r[i+1] {
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
    strings:= [
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
    for s in strings {
        cs, olen, clen := collapse(s)
        println("original : length = ${olen:2}, string = «««$s»»»")
        println("collapsed: length = ${clen:2}, string = «««$cs»»»\n")
    }
}

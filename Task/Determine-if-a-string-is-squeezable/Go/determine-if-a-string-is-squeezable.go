package main

import "fmt"

// Returns squeezed string, original and new lengths in
// unicode code points (not normalized).
func squeeze(s string, c rune) (string, int, int) {
    r := []rune(s)
    le, del := len(r), 0
    for i := le - 2; i >= 0; i-- {
        if r[i] == c && r[i] == r[i+1] {
            copy(r[i:], r[i+1:])
            del++
        }
    }
    if del == 0 {
        return s, le, le
    }
    r = r[:le-del]
    return string(r), le, len(r)
}

func main() {
    strings := []string{
        "",
        `"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln `,
        "..1111111111111111111111111111111111111111111111111111111111111117777888",
        "I never give 'em hell, I just tell the truth, and they think it's hell. ",
        "                                                   ---  Harry S Truman  ",
        "The better the 4-wheel drive, the further you'll be from help when ya get stuck!",
        "headmistressship",
        "aardvark",
        "😍😀🙌💃😍😍😍🙌",
    }
    chars := [][]rune{{' '}, {'-'}, {'7'}, {'.'}, {' ', '-', 'r'}, {'e'}, {'s'}, {'a'}, {'😍'}}

    for i, s := range strings {
        for _, c := range chars[i] {
            ss, olen, slen := squeeze(s, c)
            fmt.Printf("specified character = %q\n", c)
            fmt.Printf("original : length = %2d, string = «««%s»»»\n", olen, s)
            fmt.Printf("squeezed : length = %2d, string = «««%s»»»\n\n", slen, ss)
        }
    }
}

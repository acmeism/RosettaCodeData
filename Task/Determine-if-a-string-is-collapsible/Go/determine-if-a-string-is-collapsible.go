package main

import "fmt"

// Returns collapsed string, original and new lengths in
// unicode code points (not normalized).
func collapse(s string) (string, int, int) {
    r := []rune(s)
    le, del := len(r), 0
    for i := le - 2; i >= 0; i-- {
        if r[i] == r[i+1] {
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
    strings:= []string {
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
    for _, s := range strings {
        cs, olen, clen := collapse(s)
        fmt.Printf("original : length = %2d, string = «««%s»»»\n", olen, s)
        fmt.Printf("collapsed: length = %2d, string = «««%s»»»\n\n", clen, cs)
    }
}

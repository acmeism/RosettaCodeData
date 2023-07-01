package main

import (
    "fmt"
    "strings"
)

func main() {
    key := `
 8752390146
 ET AON RIS
5BC/FGHJKLM
0PQD.VWXYZU`
    p := "you have put on 7.5 pounds since I saw you."
    fmt.Println(p)
    c := enc(key, p)
    fmt.Println(c)
    fmt.Println(dec(key, c))
}

func enc(bd, pt string) (ct string) {
    enc := make(map[byte]string)
    row := strings.Split(bd, "\n")[1:]
    r2d := row[2][:1]
    r3d := row[3][:1]
    for col := 1; col <= 10; col++ {
        d := string(row[0][col])
        enc[row[1][col]] = d
        enc[row[2][col]] = r2d+d
        enc[row[3][col]] = r3d+d
    }
    num := enc['/']
    delete(enc, '/')
    delete(enc, ' ')
    for i := 0; i < len(pt); i++ {
        if c := pt[i]; c <= '9' && c >= '0' {
            ct += num + string(c)
        } else {
            if c <= 'z' && c >= 'a' {
                c -= 'a'-'A'
            }
            ct += enc[c]
        }
    }
    return
}

func dec(bd, ct string) (pt string) {
    row := strings.Split(bd, "\n")[1:]
    var cx [10]int
    for i := 1; i <= 10; i++ {
        cx[row[0][i]-'0'] = i
    }
    r2d := row[2][0]-'0'
    r3d := row[3][0]-'0'
    for i := 0; i < len(ct); i++ {
        var r int
        switch d := ct[i]-'0'; d {
        case r2d:
            r = 2
        case r3d:
            r = 3
        default:
            pt += string(row[1][cx[d]])
            continue
        }
        i++
        if b := row[r][cx[ct[i]-'0']]; b == '/' {
            i++
            pt += string(ct[i])
        } else {
            pt += string(b)
        }
    }
    return
}

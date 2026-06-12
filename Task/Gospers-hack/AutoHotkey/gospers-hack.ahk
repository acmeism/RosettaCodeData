#Requires AutoHotkey v2.0

GospersHack(n) {
    c := n & -n
    r := n + c
    return ((r ^ n) >> 2) // c | r
}

output := ""
for n in [1, 3, 7, 15] {
    output .= n ": "
    loop 10 {
        n := GospersHack(n)
        output .= n " "
    }
    output .= "`n"
}

MsgBox output

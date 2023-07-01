FileRead, var, *C %A_ScriptFullPath%
MsgBox, % Entropy(var)

Entropy(n) {
    a := [], len := StrLen(n), m := n
    while StrLen(m) {
        s := SubStr(m, 1, 1)
        m := RegExReplace(m, s, "", c)
        a[s] := c
    }
    for key, val in a {
        m := Log(p := val / len)
        e -= p * m / Log(2)
    }
    return, e
}

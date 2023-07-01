SetBatchLines, -1
Tick := A_TickCount    ; store tickcount
Loop, 1000000 {
    Random, x, 1, 1000000
    Random, y, 1, 1000000
    gcd(x, y)
}
t := A_TickCount - Tick    ; store ticks elapsed
MsgBox, % t / 1000 " Seconds elapsed.`n" Round(1 / (t / 1000000000), 0) " Loop iterations per second."

gcd(a, b) {    ; Euclidean GCD
    while b
        t := b, b := Mod(a, b), a := t
    return, a
}

Found := FindOneToX(100), FoundList := ""
Loop, 10
    FoundList .= "First " A_Index " found at " Found[A_Index] "`n"
MsgBox, 64, Stern-Brocot Sequence
    , % "First 15: " FirstX(15) "`n"
    .    FoundList
    .   "First 100 found at " Found[100] "`n"
    .   "GCDs of all two consecutive members are " (GCDsUpToXAreOne(1000) ? "" : "not ") "one."
return

class SternBrocot
{
    __New()
    {
        this[1] := 1
        this[2] := 1
        this.Consider := 2
    }

    InsertPair()
    {
        n := this.Consider
        this.Push(this[n] + this[n - 1], this[n])
        this.Consider++
    }
}

; Show the first fifteen members of the sequence. (This should be: 1, 1, 2, 1, 3, 2, 3, 1, 4, 3,
; 5, 2, 5, 3, 4)
FirstX(x)
{
    SB := new SternBrocot()
    while SB.MaxIndex() < x
        SB.InsertPair()
    Loop, % x
        Out .= SB[A_Index] ", "
    return RTrim(Out, " ,")
}

; Show the (1-based) index of where the numbers 1-to-10 first appears in the sequence.
; Show the (1-based) index of where the number 100 first appears in the sequence.
FindOneToX(x)
{
    SB := new SternBrocot(), xRequired := x, Found := []
    while xRequired > 0                     ; While the count of numbers yet to be found is > 0.
    {
        Loop, 2                      ; Consider the second last member and then the last member.
        {
            n := SB[i := SB.MaxIndex() - 2 + A_Index]
            ; If number (n) has not been found yet, and it is less than the maximum number to
            ; find (x), record the index (i) and decrement the count of numbers yet to be found.
            if (Found[n] = "" && n <= x)
                Found[n] := i, xRequired--
        }
        SB.InsertPair()                      ; Insert the two members that will be checked next.
    }
    return Found
}

; Check that the greatest common divisor of all the two consecutive members of the series up to
; the 1000th member, is always one.
GCDsUpToXAreOne(x)
{
    SB := new SternBrocot()
    while SB.MaxIndex() < x
        SB.InsertPair()
    Loop, % x - 1
        if GCD(SB[A_Index], SB[A_Index + 1]) > 1
            return 0
    return 1
}

GCD(a, b) {
    while b
        b := Mod(a | 0x0, a := b)
    return a
}

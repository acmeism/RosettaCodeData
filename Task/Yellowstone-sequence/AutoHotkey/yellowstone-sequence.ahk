A := [], in_seq := []
loop 30 {
    n := A_Index
    if n <=3
        A[n] := n,    in_seq[n] := true
    else while true
    {
        s := A_Index
        if !in_seq[s] && relatively_prime(s, A[n-1]) && !relatively_prime(s, A[n-2])
        {
            A[n] := s
            in_seq[s] := true
            break
        }
    }
}
for i, v in A
    result .= v ","
MsgBox % result := "[" Trim(result, ",") "]"
return
;--------------------------------------
relatively_prime(a, b){
    return (GCD(a, b) = 1)
}
;--------------------------------------
GCD(a, b) {
    while b
        b := Mod(a | 0x0, a := b)
    return a
}

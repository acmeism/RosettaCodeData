Kaprekar(L) {
    Loop, % L + ( C := 0 ) {
        S := ( N := A_Index ) ** 2
        Loop % StrLen(N) {
            B := ( B := SubStr(S,1+A_Index) ) ? B : 0
            If !B & ( (A := SubStr(S,1,A_Index)) <> 1 )
                Break
            If ( N == A+B ) {
                R .= ", " N , C++
                Break
            }
        }
    }
    Return C " Kaprekar numbers in [1-" L "]:`n" SubStr(R,3)
}

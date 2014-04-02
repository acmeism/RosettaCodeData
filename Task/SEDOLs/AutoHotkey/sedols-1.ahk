codes = 710889,B0YBKJ,406566,B0YBLH,228276,B0YBKL,557910,B0YBKR,585284,B0YBKT,B00030,ABCDEF,BBBBBBB
Loop, Parse, codes, `,
    output .= A_LoopField "`t-> " SEDOL(A_LoopField) "`n"
Msgbox %output%

SEDOL(code) {
    Static weight1:=1, weight2:=3, weight3:=1, weight4:=7, weight5:=3, weight6:=9
    If (StrLen(code) != 6)
        Return "Invalid length."
    StringCaseSense On
    Loop, Parse, code
        If A_LoopField is Number
            check_digit += A_LoopField * weight%A_Index%
        Else If A_LoopField in B,C,D,F,G,H,J,K,L,M,N,P,Q,R,S,T,V,W,X,Y,Z
            check_digit += (Asc(A_LoopField)-Asc("A") + 10) * weight%A_Index%
        Else
            Return "Invalid character."
    Return code . Mod(10-Mod(check_digit,10),10)
}

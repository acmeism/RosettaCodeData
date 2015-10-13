List1 = a,b,c
List2 = A,B,C
List3 = 1,2,3
MsgBox, % LoopMultiArrays()

List1 = a,b,c,d,e
List2 = A,B,C,D
List3 = 1,2,3
MsgBox, % LoopMultiArrays()


;---------------------------------------------------------------------------
LoopMultiArrays()

 { ; print the ith element of each
;---------------------------------------------------------------------------


    local Result
    StringSplit, List1_, List1, `,
    StringSplit, List2_, List2, `,
    StringSplit, List3_, List3, `,
    Loop, % List1_0
        Result .= List1_%A_Index% List2_%A_Index% List3_%A_Index% "`n"
    Return, Result
}

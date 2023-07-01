List1 = 1,2,3
List2 = 4,5,6

List2Array(List1 , "Array1_")
List2Array(List2 , "Array2_")

ConcatArrays("Array1_", "Array2_", "MyArray")
MsgBox, % Array2List("MyArray")


;---------------------------------------------------------------------------
ConcatArrays(A1, A2, A3) { ; concatenates the arrays A1 and A2 to A3
;---------------------------------------------------------------------------
    local i := 0
    %A3%0 := %A1%0 + %A2%0
    Loop, % %A1%0
        i++, %A3%%i% := %A1%%A_Index%
    Loop, % %A2%0
        i++, %A3%%i% := %A2%%A_Index%
}


;---------------------------------------------------------------------------
List2Array(List, Array) { ; creates an array from a comma separated list
;---------------------------------------------------------------------------
    global
    StringSplit, %Array%, List, `,
}


;---------------------------------------------------------------------------
Array2List(Array) { ; returns a comma separated list from an array
;---------------------------------------------------------------------------
    Loop, % %Array%0
        List .= (A_Index = 1 ? "" : ",") %Array%%A_Index%
    Return, List
}

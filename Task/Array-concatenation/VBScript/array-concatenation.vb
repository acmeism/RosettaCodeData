Function ArrayConcat(arr1, arr2)
    ReDim ret(UBound(arr1) + UBound(arr2) + 1)
    For i = 0 To UBound(arr1)
        ret(i) = arr1(i)
    Next
    offset = Ubound(arr1) + 1
    For i = 0 To UBound(arr2)
        ret(i + offset) = arr2(i)
    Next
    ArrayConcat = ret
End Function

arr1 = array(10,20,30)
arr2 = array(40,50,60)
WScript.Echo "arr1 = array(" & Join(arr1,", ") & ")"
WScript.Echo "arr2 = array(" & Join(arr2,", ") & ")"
arr3 = ArrayConcat(arr1, arr2)
WScript.Echo "arr1 + arr2 = array(" & Join(arr3,", ") & ")"

' Sorting algorithms/Cocktail sort with shifting bounds - VBScript

Function cocktailShakerSort(ByVal A)
    beginIdx = Lbound(A)
    endIdx = Ubound(A)-1
    Do While beginIdx <= endIdx
        newBeginIdx = endIdx
        newEndIdx = beginIdx
        For ii = beginIdx To endIdx
            If A(ii) > A(ii+1) Then
                tmp=A(ii) : A(ii)=A(ii+1) : A(ii+1)=tmp
                newEndIdx = ii
            End If
        Next
        endIdx = newEndIdx - 1
        For ii = endIdx To beginIdx Step -1
            If A(ii) > A(ii+1) Then
                tmp=A(ii) : A(ii)=A(ii+1) : A(ii+1)=tmp
                newBeginIdx = ii
            End If
        Next
        beginIdx = newBeginIdx+1
    Loop
    cocktailShakerSort=A
End Function 'cocktailShakerSort

Dim B(20)
For i=Lbound(B) To Ubound(B)
    B(i)=Int(Rnd()*100)
Next
Wscript.Echo Join(cocktailShakerSort(B)," ")

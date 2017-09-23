#NoEnv

Test := []
Loop 100 {
    Random n, 0, 999
    Test.Insert(n)
}
Result := MergeSort(Test)
Loop % Result.MaxIndex() {
    MsgBox, 1, , % Result[A_Index]
    IfMsgBox Cancel
        Break
}
Return


/*
    Function MergeSort
        Sorts an array by first recursively splitting it down to its
        individual elements and then merging those elements in their
        correct order.

    Parameters
        Array   The array to be sorted

    Returns
        The sorted array
*/
MergeSort(Array)
    {
        ; Return single element arrays
        If (! Array.HasKey(2))
            Return Array

        ; Split array into Left and Right halfs
        Left := [], Right := [], Middle := Array.MaxIndex() // 2
        Loop % Middle
            Right.Insert(Array.Remove(Middle-- + 1)), Left.Insert(Array.Remove(1))
        If (Array.MaxIndex())
            Right.Insert(Array.Remove(1))

        Left := MergeSort(Left), Right := MergeSort(Right)

        ; If all the Right values are greater than all the
        ; Left values, just append Right at the end of Left.
        If (Left[Left.MaxIndex()] <= Right[1]) {
            Loop % Right.MaxIndex()
                Left.Insert(Right.Remove(1))
            Return Left
        }
        ; Loop until one of the arrays is empty
        While(Left.MaxIndex() and Right.MaxIndex())
            Left[1] <= Right[1] ? Array.Insert(Left.Remove(1))
                                : Array.Insert(Right.Remove(1))

        Loop % Left.MaxIndex()
            Array.Insert(Left.Remove(1))

        Loop % Right.MaxIndex()
            Array.Insert(Right.Remove(1))

        Return Array
    }

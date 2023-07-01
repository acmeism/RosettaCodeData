Private Function Ethiopian_Multiplication_Non_Optimized(First As Long, Second As Long) As Long
Dim Left_Hand_Column As New Collection, Right_Hand_Column As New Collection, i As Long, temp As Long

'Take two numbers to be multiplied and write them down at the top of two columns.
    Left_Hand_Column.Add First, CStr(First)
    Right_Hand_Column.Add Second, CStr(Second)
'In the left-hand column repeatedly halve the last number, discarding any remainders,
    'and write the result below the last in the same column, until you write a value of 1.
    Do
        First = lngHalve(First)
        Left_Hand_Column.Add First, CStr(First)
    Loop While First > 1
'In the right-hand column repeatedly double the last number and write the result below.
    'stop when you add a result in the same row as where the left hand column shows 1.
    For i = 2 To Left_Hand_Column.Count
        Second = lngDouble(Second)
        Right_Hand_Column.Add Second, CStr(Second)
    Next

'Examine the table produced and discard any row where the value in the left column is even.
    For i = Left_Hand_Column.Count To 1 Step -1
        If IsEven(Left_Hand_Column(i)) Then Right_Hand_Column.Remove CStr(Right_Hand_Column(i))
    Next
'Sum the values in the right-hand column that remain to produce the result of multiplying
    'the original two numbers together
    For i = 1 To Right_Hand_Column.Count
        temp = temp + Right_Hand_Column(i)
    Next
    Ethiopian_Multiplication_Non_Optimized = temp
End Function

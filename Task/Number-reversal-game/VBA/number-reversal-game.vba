Private Function shuffle(ByVal a As Variant) As Variant
    Dim t As Variant, i As Integer
    For i = UBound(a) To LBound(a) + 1 Step -1
        j = Int((UBound(a) - LBound(a) + 1) * Rnd + LBound(a))
        t = a(i)
        a(i) = a(j)
        a(j) = t
    Next i
    shuffle = a
End Function
Private Sub reverse(ByRef a As Variant, n As Integer)
    Dim b As Variant
    b = a
    For i = 1 To n
        a(i) = b(n + 1 - i)
    Next i
End Sub
Public Sub game()
    Debug.Print "Given a jumbled list of the numbers 1 to 9"
    Debug.Print "you must select how many digits from the left to reverse."
    Debug.Print "Your goal is to get the digits in order with 1 on the left and 9 on the right."

    inums = [{1,2,3,4,5,6,7,8,9}]
    Dim nums As Variant
    Dim turns As Integer, flip As Integer

    shuffled = False
    Do While Not shuffled
        nums = shuffle(inums)
        For i = LBound(nums) To UBound(nums)
            If nums(i) <> inums(i) Then
                shuffled = True
                Exit For
            End If
        Next i
    Loop


    Do While True
        Debug.Print turns; ":";
        For Each x In nums: Debug.Print x;: Next x
        Debug.Print
        flag = False
        For i = LBound(nums) To UBound(nums)
            If nums(i) <> inums(i) Then
                flag = True
                Exit For
            End If
        Next i
        If flag Then
            flip = InputBox(" -- How many numbers should be flipped? ")
            reverse nums, flip
            turns = turns + 1
        Else
            Exit Do
        End If
    Loop

    Debug.Print "You took"; turns; "turns to put the digits in order."
End Sub

'Best Shuffle Task
'VBScript Implementation

Function bestshuffle(s)
    Dim arr:Redim arr(Len(s)-1)

    'The Following Does the toCharArray() Functionality
    For i = 0 To Len(s)-1
        arr(i) = Mid(s, i + 1, 1)
    Next

    arr = shuffler(arr)     'Make this line a comment for deterministic solution
    For i = 0 To UBound(arr):Do
        If arr(i) <> Mid(s, i + 1, 1) Then Exit Do
        For j = 0 To UBound(arr)
            If arr(i) <> arr(j) And arr(i) <> Mid(s, j + 1, 1) And arr(j) <> Mid(s, i + 1, 1) Then
                tmp = arr(i)
                arr(i) = arr(j)
                arr(j) = tmp
            End If
        Next
    Loop While False:Next

    shuffled_word = Join(arr,"")

    'This section is the scorer
    score = 0
    For k = 1 To Len(s)
        If Mid(s,k,1) = Mid(shuffled_word,k,1) Then
            score = score + 1
        End If
    Next

    bestshuffle = shuffled_word & ",(" & score & ")"
End Function

Function shuffler(array)
    Set rand = CreateObject("System.Random")
    For i = UBound(array) to 0 Step -1
       r = rand.next_2(0, i + 1)
       tmp = array(i)
       array(i) = array(r)
       array(r) = tmp
    Next
    shuffler = array
End Function

'Testing the function
word_list = Array("abracadabra","seesaw","elk","grrrrrr","up","a")
For Each word In word_list
    WScript.StdOut.WriteLine word & "," & bestshuffle(word)
Next

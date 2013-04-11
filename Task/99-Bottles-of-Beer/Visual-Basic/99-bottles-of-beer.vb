Sub Main()
    Const bottlesofbeer As String = " bottles of beer"
    Const onthewall As String = " on the wall"
    Const takeonedown As String = "Take one down, pass it around"
    Const onebeer As String = "1 bottle of beer"

    Dim bottles As Long

    For bottles = 99 To 3 Step -1
        Debug.Print CStr(bottles) & bottlesofbeer & onthewall
        Debug.Print CStr(bottles) & bottlesofbeer
        Debug.Print takeonedown
        Debug.Print CStr(bottles - 1) & bottlesofbeer & onthewall
        Debug.Print
    Next

    Debug.Print "2" & bottlesofbeer & onthewall
    Debug.Print "2" & bottlesofbeer
    Debug.Print takeonedown
    Debug.Print onebeer & onthewall
    Debug.Print

    Debug.Print onebeer & onthewall
    Debug.Print onebeer
    Debug.Print takeonedown
    Debug.Print "No more" & bottlesofbeer & onthewall
    Debug.Print

    Debug.Print "No" & bottlesofbeer & onthewall
    Debug.Print "No" & bottlesofbeer
    Debug.Print "Go to the store, buy some more"
    Debug.Print "99" & bottlesofbeer & onthewall
End Sub

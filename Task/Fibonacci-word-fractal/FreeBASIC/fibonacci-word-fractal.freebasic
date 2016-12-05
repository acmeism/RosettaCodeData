' version 23-06-2015
' compile with: fbc -s console "filename".bas

Dim As String fw1, fw2, fw3
Dim As Integer a, b, d , i, n , x, y, w, h
Dim As Any Ptr img_ptr, scr_ptr

' data for screen/buffer size
Data 1, 2, 3, 2, 2, 2, 2, 2, 7, 10, 8, 14
Dim As Integer s(38,2)
For i = 3 To 9
    Read s(i,1) : Read s(i,2)
Next
For i = 9 To 38 Step 6
    s(i, 1) = s(i -1, 1) +2 : s(i, 2) = s(i -1, 1) + s(i -1, 2)
    s(i +1, 1) = s(i, 2) +2 : s(i +1, 2) = s(i, 2)
    s(i +2, 1) = s(i, 1) + s(i, 2) : s(i +2, 2) = s(i, 2)
    s(i +3, 1) = s(i +1, 1 ) + s(i +2, 1) : s(i +3, 2) = s(i ,2)
    s(i +4, 1) = s(i +3, 1) : s(i +4, 2) = s(i +3, 1) + 2
    s(i +5, 1) = s(i +3, 1) : s(i +5, 2) = s(i +3, 2) + s(i +4, 2) +2
Next

' we need to set screen in order to create image buffer in memory
Screen 21
scr_ptr = ScreenPtr()
If (scr_ptr = 0) Then
    Print "Error: graphics screen not initialized."
    Sleep
    End -1
End If

Do
    Cls
    Do

        Print
        Print "For wich n do you want the Fibonacci Word fractal (3 to 35)."
        While Inkey <> "" : fw1 = Inkey : Wend ' empty keyboard buffer
        Input "Enter or a value smaller then 3 to stop: "; n
        If n < 3 Then
            Print : Print "Stopping."
            Sleep 3000,1
            End
        EndIf
        If n > 35 then
            Print : Print "Fractal is to big, unable to create it."
            Sleep 3000,1
            Continue Do
        End If
    Loop Until n < 36

    fw1 = "1" : fw2 = "0" ' construct the string
    For i = 3 To n
        fw3 = fw2 + fw1
        Swap fw1, fw2    ' swap pointers of fw1 and fw2
        Swap fw2, fw3    ' swap pointers of fw2 and fw3
    Next
    fw1 = "" : fw3 = ""  ' free up memory

    w = s(n, 1) +1 : h = s(n, 2) +1
    ' allocate memory for a buffer to hold the image
    ' use 8 bits to hold the color
    img_ptr = ImageCreate(w,h,0,8)
    If img_ptr = 0 Then  ' check if we have created a image buffer
        Print "Failed to create image."
        Sleep
        End -1
    End If

    x = 0:  y = h -1  : d = 1    ' set starting point and direction flag
    PSet img_ptr, (x, y)         ' set start point
    For a = 1 To Len(fw2)
        Select Case As Const d
            Case 0
                x = x + 2
            Case 1
                y = y - 2
            Case 2
                x = x - 2
            Case 3
                y = y + 2
        End Select
        Line  img_ptr, -(x, y)
        b = fw2[a-1] - Asc("0")
        If b = 0 Then
            If (a And 1) Then
                d = d + 3    ' a = odd
            Else
                d = d + 1    ' a = even
            End If
            d = d And 3
        End If
    Next

    If n < 24 Then  ' size is smaller then screen dispay fractal
        Cls
        Put (5, 5),img_ptr, PSet
    Else
        Print
        Print "Fractal is to big for display."
    End If
    ' saves fractal as bmp file (8 bit palette)
    If n > 23 Then h = 80
    Draw String (0, h +16), "saving fractal as fibword" + Str(n) + ".bmp."
    BSave "F_Word" + Str(n) + ".bmp", img_ptr
    Draw String (0, h +32), "Hit any key to continue."
    Sleep
    ImageDestroy(img_ptr) ' free memory holding the image
Loop

' version 12-04-2017
' compile with: fbc -s gui
' Computer Graphics Tutorial (lodev.org), last example

#Define dist(a, b, c, d) Sqr(((a - c) * (a - c) + (b - d) * (b - d)))

Const As ULong w = 256
Const As ULong h = 256
ScreenRes w, h, 24
WindowTitle ("Plasma effect")

Dim As ULong x, y
Dim As UByte c
Dim As Double time_, value

Do
    time_ += .99
    ScreenLock
    For x = 0 To w -1
        For y = 0 To h -1
            value = Sin(dist(x + time_, y, 128, 128) / 8) _
            + Sin(dist(x, y, 64, 64) / 8) _
            + Sin(dist(x, y + time_ / 7, 192, 64) / 7) _
            + Sin(dist(x, y, 192, 100) / 8) + 4
            ' c = Int(value) * 32
            c = int(value * 32)
            PSet(x, y), RGB(c, c * 2, 255 - c)
        Next
    Next
    ScreenUnLock
    Sleep 1

    If Inkey <> "" Or Inkey = Chr(255) + "k" Then
        End
    End If

Loop

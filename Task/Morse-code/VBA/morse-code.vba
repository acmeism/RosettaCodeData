Option Explicit

Private Declare Function Beep Lib "kernel32" (ByVal dwFreq As Long, ByVal dwDuration As Long) As Long
Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Private Const MORSE_ALPHA As String = ".-,-...,-.-.,-..,.,..-.,--.,....,..,.---,-.-,.-..,--,-.,---,.--.,--.-,.-.,...,-,..-,...-,.--,-..-,-.--,--.."
Private Const MORSE_NUMERIC As String = "-----,.----,..---,...--,....-,.....,-....,--...,---..,----."

Private Const ONE_UNIT As Integer = 100

Private Const BEEP_DOT As Integer = ONE_UNIT
Private Const BEEP_DASH As Integer = 3 * ONE_UNIT
Private Const BEEP_OTHER As Integer = 7 * ONE_UNIT
Private Const DELAY As Integer = ONE_UNIT
Private Const LETTERS_DELAY As Integer = 3 * ONE_UNIT
Private Const SPACE_DELAY As Integer = 7 * ONE_UNIT

Private Const FREQUENCY_CHARS As Integer = 1200
Private Const FREQUENCY_OTHERCHARS As Integer = 400

Sub Main()
Dim p$, temp$
    p = ToMorse("Hel/lo 123 world")
    temp = Replace(p, "+", "")
    Debug.Print Replace(temp, "_", "")
    PlayMorse p
End Sub

Private Function ToMorse(s As String) As String
Dim i&, t$, j&
    s = UCase(s)
    For i = 1 To Len(s)
        j = Asc(Mid(s, i, 1))
        Select Case j
            Case 65 To 90 'alpha
                t = t & Split(MORSE_ALPHA, ",")(j - 65) & "+" ' "+" ==> separate each characters
            Case 48 To 57 'numerics
                t = t & Split(MORSE_NUMERIC, ",")(j - 48) & "+"
            Case 32 'space
                t = t & " " & "+"
            Case Else 'others
                t = t & "_" & "+"
        End Select
    Next i
    ToMorse = t
End Function

Private Sub PlayMorse(s As String)
Dim i&
    For i = 1 To Len(s)
        Select Case Mid(s, i, 1)
            Case ".": Beep FREQUENCY_CHARS, BEEP_DOT
            Case "-": Beep FREQUENCY_CHARS, BEEP_DASH
            Case "_": Beep FREQUENCY_OTHERCHARS, BEEP_OTHER
            Case "+": Sleep LETTERS_DELAY
            Case " ": Sleep SPACE_DELAY
        End Select
        Sleep DELAY
    Next i
End Sub

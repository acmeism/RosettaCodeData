Option Explicit

Sub Main_Pig()
Dim Scs() As Byte, Ask As Integer, Np As Boolean, Go As Boolean
Dim Cp As Byte, Rd As Byte, NbP As Byte, ScBT As Byte
    'You can adapt these Const, but don't touch the "¤¤¤¤"
    Const INPTXT As String = "Enter number of players : "
    Const INPTITL As String = "Numeric only"
    Const ROL As String = "Player ¤¤¤¤ rolls the die."
    Const MSG As String = "Do you want to ""hold"" : "
    Const TITL As String = "Total if you keep : "
    Const RES As String = "The die give you : ¤¤¤¤ points."
    Const ONE As String = "The die give you : 1 point. Sorry!" & vbCrLf & "Next player."
    Const WIN As String = "Player ¤¤¤¤ win the Pig Dice Game!"
    Const STW As Byte = 100

    Randomize Timer
    NbP = Application.InputBox(INPTXT, INPTITL, 2, Type:=1)
    ReDim Scs(1 To NbP)
    Cp = 1
    Do
        ScBT = 0
        Do
            MsgBox Replace(ROL, "¤¤¤¤", Cp)
            Rd = Int((Rnd * 6) + 1)
            If Rd > 1 Then
                MsgBox Replace(RES, "¤¤¤¤", Rd)
                ScBT = ScBT + Rd
                If Scs(Cp) + ScBT >= STW Then
                    Go = True
                    Exit Do
                End If
                Ask = MsgBox(MSG & ScBT, vbYesNo, TITL & Scs(Cp) + ScBT)
                If Ask = vbYes Then
                    Scs(Cp) = Scs(Cp) + ScBT
                    Np = True
                End If
            Else
                MsgBox ONE
                Np = True
            End If
        Loop Until Np
        If Not Go Then
            Np = False
            Cp = Cp + 1
            If Cp > NbP Then Cp = 1
        End If
    Loop Until Go
    MsgBox Replace(WIN, "¤¤¤¤", Cp)
End Sub

Option Explicit

Sub Ant()
  Dim TablDatas(1 To 200, 1 To 256) As String, sDir As String, sFile As String, Str As String
  Dim ColA As Integer, LigA As Long, ColF As Integer, LigF As Long, i As Long, j As Integer, Num As Long
  Dim Top As Boolean, Left As Boolean, Bottom As Boolean, Right As Boolean

    'init variables
    Select Case Int(Rnd(4) * 4)
      Case 0: Top = True
      Case 1: Right = True
      Case 2: Bottom = True
      Case 3: Left = True
    End Select

    LigF = 80
    ColF = 50
    For i = 1 To 200
        For j = 1 To 256
            TablDatas(i, j) = " "
        Next
    Next
    'directory
    sDir = "/Users/mjreed/Desktop/"
    'name txt file
    sFile = "Langton_Ant.txt"

    'start
    Dim Dir As String
    For i = 1 To 15000
        LigA = LigF
        ColA = ColF

        If LigA = 1 Or ColA = 1 Or ColA = 256 Or LigA = 200 Then GoTo Fin
        If TablDatas(LigA, ColA) = " " Then
            TablDatas(LigA, ColA) = "#"
            Select Case True
                Case Top: Top = False: Right = True: LigF = LigA: ColF = ColA + 1
                Case Left: Left = False: Top = True: LigF = LigA - 1: ColF = ColA
                Case Bottom: Bottom = False: Left = True: LigF = LigA: ColF = ColA - 1
                Case Right: Right = False: Bottom = True: LigF = LigA + 1: ColF = ColA
            End Select
        Else
            TablDatas(LigA, ColA) = " "
            Select Case True
                Case Top: Top = False: Left = True: LigF = LigA: ColF = ColA - 1
                Case Left: Left = False: Bottom = True: LigF = LigA + 1: ColF = ColA
                Case Bottom: Bottom = False: Right = True: LigF = LigA: ColF = ColA + 1
                Case Right: Right = False: Top = True: LigF = LigA - 1: ColF = ColA
            End Select
        End If
    Next i
Fin:
    'result in txt file
    Num = FreeFile
    Open sDir & sFile For Output As #Num

    For i = 1 To UBound(TablDatas, 1)
        Str = vbNullString
        For j = 1 To UBound(TablDatas, 2)
            Str = Str & TablDatas(i, j)
        Next j
        Print #Num, Str
    Next i
    Close #Num
    Exit Sub
End Sub

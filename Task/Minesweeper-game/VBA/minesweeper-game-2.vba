Option Explicit

Public myForm As Object
Public Fram As MSForms.Frame
Public Dico As Object
Public DicoParent As Object
Public TypeObjet As String
Public Mine As Boolean
Public boolFind As Boolean
Private strName As String
Private cNeighbours() As cMinesweeper
Public WithEvents myButton As MSForms.CommandButton
Private Const WIDTH_BUTT As Byte = 18
Private Const MIN_OF_LINES As Byte = 7
Private Const MAX_OF_LINES As Byte = 30 - MIN_OF_LINES
Private Const MIN_COL As Byte = 7
Private Const MAX_COL As Byte = 40 - MIN_COL
Private Const POURCENT_SIMPLE As Byte = 10
Private Const POURCENT_MEDIUM As Byte = 2 * POURCENT_SIMPLE
Private Const POURCENT_HARD As Byte = 3 * POURCENT_SIMPLE
Private Const COLOR_MINE As Long = &H188B0
Private Const COLOR_BOUTON As Long = &H8000000F
Private Const COLOR_MINE_POSSIBLE As Long = &H80FF&
Private Const COLOR_MINE_PROB As Long = &H8080FF

Property Get Neighbours() As cMinesweeper()
   Neighbours = cNeighbours
End Property

Property Let Neighbours(ByRef nouvNeighbours() As cMinesweeper)
   cNeighbours = nouvNeighbours
End Property

Private Sub Class_Initialize()
    Set Dico = CreateObject("Scripting.dictionary")
End Sub

Public Sub Show(ByRef Difficult As Long, Optional CheatMode As Boolean = False)
    On Error GoTo ErrorParametresMacros
    With ThisWorkbook.VBProject: End With

    Dim Lin As Long, Col As Long, NbLines As Long, NbColumns As Long
    Dim NbMines As Long, MineAdress() As String, CptMine As Long
    Randomize Timer
    NbLines = Int(MAX_OF_LINES * Rnd) + MIN_OF_LINES
    NbColumns = Int(MAX_COL * Rnd) + MIN_COL
    Select Case Difficult
        Case 0: Difficult = POURCENT_SIMPLE
        Case 1: Difficult = POURCENT_MEDIUM
        Case 2: Difficult = POURCENT_HARD
    End Select
    PlaysCount = 0
    NbMines = (NbLines * NbColumns) * Difficult \ 100
    ReDim MineAdress(NbMines)
    For CptMine = 1 To NbMines
        MineAdress(CptMine) = Int(NbColumns * Rnd) + 1 & "-" & Int(NbLines * Rnd) + 1
    Next
    Call Create_Usf("Minesweeper", (NbColumns * WIDTH_BUTT) + 5, (NbLines * WIDTH_BUTT) + 22)
    Call New_Frame("Fram1", "", NbColumns * WIDTH_BUTT, NbLines * WIDTH_BUTT)
    For Lin = 1 To NbLines
        For Col = 1 To NbColumns
            Call Dico("Fram1").New_Button(Col & "-" & Lin, "", WIDTH_BUTT * (Col - 1), WIDTH_BUTT * (Lin - 1), IsIn(Col & "-" & Lin, MineAdress), CheatMode)
            Set Dico("Fram1").Dico(Col & "-" & Lin).DicoParent = Dico("Fram1").Dico
        Next Col
    Next Lin
    MsgBox "Start With " & NbMines & " mines." & vbCrLf & "Good luck !"
    myForm.Show
    Exit Sub
ErrorParametresMacros:
    MsgBox "Programmatic Access to Visual Basic Project is not trusted. See it in Macro's security!"
End Sub

Private Sub Create_Usf(strTitle As String, dblWidth As Double, dblHeight As Double)
    TypeObjet = "UserForm"
    Set myForm = ThisWorkbook.VBProject.VBComponents.Add(3)
    strName = myForm.Name
    VBA.UserForms.Add (strName)
    Set myForm = UserForms(UserForms.Count - 1)
    With myForm
        .Caption = strTitle
        .Width = dblWidth
        .Height = dblHeight
    End With
End Sub

Public Sub New_Frame(myStringName As String, strTitle As String, dblWidth As Double, dblHeight As Double)
    If Dico.Exists(myStringName) = True Then Exit Sub
    Dim myClass As New cMinesweeper
    Select Case TypeObjet
        Case "UserForm": Set myClass.Fram = myForm.Controls.Add("forms.frame.1")
        Case "Frame": Set myClass.Fram = Fram.Controls.Add("forms.frm.1")
    End Select
    myClass.TypeObjet = "Frame"
    Set myClass.myForm = myForm
    With myClass.Fram
        .Name = myStringName
        .Caption = strTitle
        .Move 0, 0, dblWidth, dblHeight
    End With
    Dico.Add myStringName, myClass
    Set myClass = Nothing
End Sub

Public Sub New_Button(myStringName As String, strTitle As String, dblLeft As Double, dblTop As Double, boolMine As Boolean, Optional CheatMode As Boolean)
    If Dico.Exists(myStringName) = True Then Exit Sub
    Dim myClass As New cMinesweeper
    Select Case TypeObjet
        Case "UserForm": Set myClass.myButton = myForm.Controls.Add("forms.CommandButton.1")
        Case "Frame": Set myClass.myButton = Fram.Controls.Add("forms.CommandButton.1")
    End Select
    Set myClass.myForm = myForm
    myClass.Mine = boolMine
    With myClass.myButton
        .Name = myStringName
        .Caption = strTitle
        .Move dblLeft, dblTop, WIDTH_BUTT, WIDTH_BUTT
        If CheatMode Then
            If boolMine Then .BackColor = COLOR_MINE Else .BackColor = COLOR_BOUTON
        Else
            .BackColor = COLOR_BOUTON
        End If
    End With
    Dico.Add myStringName, myClass
    Set myClass = Nothing
End Sub

Private Function IsIn(strAddress As String, Tb) As Boolean
    Dim i As Long
    For i = 0 To UBound(Tb)
        If Tb(i) = strAddress Then IsIn = True: Exit Function
    Next i
End Function

Private Sub myButton_MouseDown(ByVal Button As Integer, ByVal Shift As Integer, ByVal x As Single, ByVal y As Single)
    If Button = XlMouseButton.xlSecondaryButton Then
        Select Case myButton.Caption
            Case "": myButton.Caption = "!": myButton.BackColor = COLOR_MINE_PROB
            Case "!": myButton.Caption = "?": myButton.BackColor = COLOR_MINE_POSSIBLE
            Case "?": myButton.Caption = "": myButton.BackColor = COLOR_BOUTON
            Case Else:
        End Select
    ElseIf Button = XlMouseButton.xlPrimaryButton Then
        PlaysCount = PlaysCount + 1
        If PlaysCount = 1 Then vTime = Timer
        If DicoParent.Item(myButton.Name).Mine Then
            Call Show_Mines
            MsgBox "Game over!"
            myForm.Hide
        Else
            myButton.BackColor = COLOR_BOUTON
            Dim myClass As cMinesweeper
            Set myClass = DicoParent.Item(myButton.Name)
            Call Demine(myClass)
        End If
    End If
    If IsVictoriousGame Then
        Call Show_Mines
        MsgBox "You win." & vbCrLf & "in : " & PlaysCount & " clicks, and in : " & Timer - vTime & " seconds."
        Erase Neighbours
        myForm.Hide
    End If
End Sub

Private Sub Show_Mines()
Dim cle As Variant
    For Each cle In DicoParent.Keys
        If DicoParent.Item(cle).Mine Then DicoParent.Item(cle).myButton.BackColor = COLOR_MINE
    Next
End Sub

Private Sub Demine(Cl As cMinesweeper)
Dim NbMines As Integer
    NbMines = Count_Of_Mines(Cl.myButton.Name)
    If NbMines > 0 Then
        Cl.myButton.Caption = NbMines
        Cl.boolFind = True
        Cl.myButton.BackColor = COLOR_BOUTON
    Else
        If Cl.boolFind = False Then
            Cl.boolFind = True
            Cl.myButton.Visible = False
            What_Neighbours Cl
            Dim Tb() As cMinesweeper, i As Integer
            Tb = Cl.Neighbours
            For i = 0 To UBound(Tb)
                Demine Tb(i)
            Next
        End If
    End If
End Sub

Private Function Count_Of_Mines(Bout As String) As Integer
Dim i As Integer, j As Integer, Col As Integer, Lin As Integer
Dim myClass As cMinesweeper
    For i = -1 To 1
        For j = -1 To 1
            Col = CInt(Split(Bout, "-")(0)) + i
            Lin = CInt(Split(Bout, "-")(1)) + j
            If DicoParent.Exists(Col & "-" & Lin) Then
                Set myClass = DicoParent.Item(Col & "-" & Lin)
                If myClass.Mine Then Count_Of_Mines = Count_Of_Mines + 1
            End If
        Next j
    Next i
End Function

Private Sub What_Neighbours(Cl As cMinesweeper)
Dim i As Integer, j As Integer, Col As Integer, Lin As Integer
Dim myClass As cMinesweeper, ListNeighbours() As cMinesweeper, cpt As Byte
    For i = -1 To 1
        For j = -1 To 1
            Col = CInt(Split(Cl.myButton.Name, "-")(0)) + i
            Lin = CInt(Split(Cl.myButton.Name, "-")(1)) + j
            If DicoParent.Exists(Col & "-" & Lin) And Cl.myButton.Name <> Col & "-" & Lin Then
                Set myClass = DicoParent.Item(Col & "-" & Lin)
                ReDim Preserve ListNeighbours(cpt)
                Set ListNeighbours(cpt) = myClass
                cpt = cpt + 1
            End If
        Next j
    Next i
    Cl.Neighbours = ListNeighbours
End Sub

Private Function IsVictoriousGame() As Boolean
Dim cle As Variant
    For Each cle In DicoParent.Keys
        If DicoParent.Item(cle).boolFind = False And DicoParent.Item(cle).Mine = False Then IsVictoriousGame = False: Exit Function
    Next
    IsVictoriousGame = True
End Function

Private Sub Class_Terminate()
    Dim VBComp
    Set Dico = Nothing
    Set DicoParent = Nothing
    If strName <> "" Then
        Set VBComp = ThisWorkbook.VBProject.VBComponents(strName)
        ThisWorkbook.VBProject.VBComponents.Remove VBComp
    End If
End Sub

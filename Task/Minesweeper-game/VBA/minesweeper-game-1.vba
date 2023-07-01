Option Explicit

Public vTime As Single
Public PlaysCount As Long

Sub Main_MineSweeper()
Dim Userf As New cMinesweeper
'Arguments :
    'First arg is level : 0 = easy, 1 = middle, 2 = difficult
    'Second arg is Cheat Mode : True if you want to cheat...
    Userf.Show 0, True
End Sub

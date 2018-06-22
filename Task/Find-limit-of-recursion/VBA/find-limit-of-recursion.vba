Option Explicit

Sub Main()
    Debug.Print "The limit is : " & Limite_Recursivite(0)
End Sub

Function Limite_Recursivite(Cpt As Long) As Long
    Cpt = Cpt + 1               'Count
    On Error Resume Next
    Limite_Recursivite Cpt      'recurse
    On Error GoTo 0
    Limite_Recursivite = Cpt    'return
End Function

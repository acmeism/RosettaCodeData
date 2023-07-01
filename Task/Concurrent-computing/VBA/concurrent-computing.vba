Private Sub Enjoy()
    Debug.Print "Enjoy"
End Sub
Private Sub Rosetta()
    Debug.Print "Rosetta"
End Sub
Private Sub Code()
    Debug.Print "Code"
End Sub
Public Sub concurrent()
    when = Now + TimeValue("00:00:01")
    Application.OnTime when, "Enjoy"
    Application.OnTime when, "Rosetta"
    Application.OnTime when, "Code"
End Sub

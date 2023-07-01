Sub C_S_Switch()
    Dim myName
    myName = 2
    Debug.Print Switch(myName = 1, "Bryan", myName = 2, "Justin", myName = 3, "John")
    'return : Justin
End Sub

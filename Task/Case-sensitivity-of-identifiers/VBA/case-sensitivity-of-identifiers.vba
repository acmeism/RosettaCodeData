Public Sub case_sensitivity()
    'VBA does not allow variables that only differ in case
    'The VBA IDE vbe will rename variable 'dog' to 'DOG'
    'when trying to define a second variable 'DOG'
    Dim DOG As String
    DOG = "Benjamin"
    DOG = "Samba"
    DOG = "Bernie"
    Debug.Print "There is just one dog named " & DOG
End Sub

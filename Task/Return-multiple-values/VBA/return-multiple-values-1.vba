Type Contact
    Name As String
    firstname As String
    Age As Byte
End Type

Function SetContact(N As String, Fn As String, A As Byte) As Contact
    SetContact.Name = N
    SetContact.firstname = Fn
    SetContact.Age = A
End Function

'For use :
Sub Test_SetContact()
Dim Cont As Contact

    Cont = SetContact("SMITH", "John", 23)
    Debug.Print Cont.Name & " " & Cont.firstname & ", " & Cont.Age & " years old."
End Sub

Public Sub Main()
    Dim c As VBA.Collection

    ' initial state: Nothing
    Debug.Print c Is Nothing

    ' create an instance
    Set c = New VBA.Collection
    Debug.Print Not c Is Nothing

    ' release the instance
    Set c = Nothing
    Debug.Print c Is Nothing
End Sub

Public Sub Main()
Dim c As VBA.Collection

' initial state: Nothing
Debug.Assert c Is Nothing

' create an instance
Set c = New VBA.Collection
Debug.Assert Not c Is Nothing

' release the instance
Set c = Nothing
Debug.Assert c Is Nothing

End Sub

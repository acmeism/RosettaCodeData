Dim s As String

' Assign empty string:
s = ""
' or
s = String.Empty

' Check for empty string only (false if s is null):
If s IsNot Nothing AndAlso s.Length = 0 Then
End If

' Check for null or empty (more idiomatic in .NET):
If String.IsNullOrEmpty(s) Then
End If

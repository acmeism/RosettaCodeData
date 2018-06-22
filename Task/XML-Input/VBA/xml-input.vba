Option Explicit

Const strXml As String = "" & _
"<Students>" & _
    "<Student Name=""April"" Gender=""F"" DateOfBirth=""1989-01-02"" />" & _
    "<Student Name=""Bob"" Gender=""M""  DateOfBirth=""1990-03-04"" />" & _
    "<Student Name=""Chad"" Gender=""M""  DateOfBirth=""1991-05-06"" />" & _
    "<Student Name=""Dave"" Gender=""M""  DateOfBirth=""1992-07-08"">" & _
        "<Pet Type=""dog"" Name=""Rover"" />" & _
    "</Student>" & _
    "<Student DateOfBirth=""1993-09-10"" Gender=""F"" Name=""&#x00C9;mily"" />" & _
"</Students>"

Sub Main_Xml()
Dim MyXml As Object
Dim myNodes, myNode

    With CreateObject("MSXML2.DOMDocument")
        .LoadXML strXml
        Set myNodes = .getElementsByTagName("Student")
    End With
    If Not myNodes Is Nothing Then
        For Each myNode In myNodes
            Debug.Print myNode.getAttribute("Name")
        Next
    End If
    Set myNodes = Nothing
End Sub

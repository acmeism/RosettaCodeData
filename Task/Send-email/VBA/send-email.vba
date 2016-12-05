Option Explicit
Const olMailItem = 0

Sub SendMail(MsgTo As String, MsgTitle As String, MsgBody As String)
    Dim OutlookApp As Object, Msg As Object
    Set OutlookApp = CreateObject("Outlook.Application")
    Set Msg = OutlookApp.CreateItem(olMailItem)
    With Msg
        .To = MsgTo
        .Subject = MsgTitle
        .Body = MsgBody
        .Send
    End With
    Set OutlookApp = Nothing
End Sub

Sub Test()
    SendMail "somebody@somewhere", "Title", "Hello"
End Sub

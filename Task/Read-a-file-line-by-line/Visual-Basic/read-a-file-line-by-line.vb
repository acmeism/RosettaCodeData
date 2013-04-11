' Read lines from a file
'
' (c) Copyright 1993 - 2011 Mark Hobley
'
' This code was ported from an application program written in Microsoft Quickbasic
'
' This code can be redistributed or modified under the terms of version 1.2 of
' the GNU Free Documentation Licence as published by the Free Software Foundation.

Sub readlinesfromafile()
  var.filename = "foobar.txt"
  var.filebuffersize = ini.inimaxlinelength
  Call openfileread
  If flg.error = "Y" Then
    flg.abort = "Y"
    Exit Sub
  End If
  If flg.exists <> "Y" Then
    flg.abort = "Y"
    Exit Sub
  End If
readfilelabela:
  Call readlinefromfile
  If flg.error = "Y" Then
    flg.abort = "Y"
    Call closestream
    flg.error = "Y"
    Exit Sub
  End If
  If flg.endoffile <> "Y" Then
    ' We have a line from the file
    Print message$
    GoTo readfilelabela
  End If
  ' End of file reached
  ' Close the file and exit
  Call closestream
  Exit Sub
End Sub

Sub openfileread()
  flg.streamopen = "N"
  Call checkfileexists
  If flg.error = "Y" Then Exit Sub
  If flg.exists <> "Y" Then Exit Sub
  Call getfreestream
  If flg.error = "Y" Then Exit Sub
  var.errorsection = "Opening File"
  var.errordevice = var.filename
  If ini.errortrap = "Y" Then
    On Local Error GoTo openfilereaderror
  End If
  flg.endoffile = "N"
  Open var.filename For Input As #var.stream Len = var.filebuffersize
  flg.streamopen = "Y"
  Exit Sub
openfilereaderror:
  var.errorcode = Err
  Call errorhandler
  resume '!!
End Sub

Public Sub checkfileexists()
  var.errorsection = "Checking File Exists"
  var.errordevice = var.filename
  If ini.errortrap = "Y" Then
    On Local Error GoTo checkfileexistserror
  End If
  flg.exists = "N"
  If Dir$(var.filename, 0) <> "" Then
    flg.exists = "Y"
  End If
  Exit Sub
checkfileexistserror:
  var.errorcode = Err
  Call errorhandler
End Sub

Public Sub getfreestream()
  var.errorsection = "Opening Free Data Stream"
  var.errordevice = ""
  If ini.errortrap = "Y" Then
    On Local Error GoTo getfreestreamerror
  End If
  var.stream = FreeFile
  Exit Sub
getfreestreamerror:
  var.errorcode = Err
  Call errorhandler
  resume '!!
End Sub

Sub closestream()
  If ini.errortrap = "Y" Then
    On Local Error GoTo closestreamerror
  End If
  var.errorsection = "Closing Stream"
  var.errordevice = ""
  flg.resumenext = "Y"
  Close #var.stream
  If flg.error = "Y" Then
    flg.error = "N"
    '!! Call unexpectederror
  End If
  flg.streamopen = "N"
  Exit Sub
closestreamerror:
  var.errorcode = Err
  Call errorhandler
  resume next
End Sub

Public Sub errorhandler()
  tmp$ = btrim$(var.errorsection)
  tmp2$ = btrim$(var.errordevice)
  If tmp2$ <> "" Then
    tmp$ = tmp$ + " (" + tmp2$ + ")"
  End If
  tmp$ = tmp$ + " : " + Str$(var.errorcode)
  tmp1% = MsgBox(tmp$, 0, "Error!")
  flg.error = "Y"
  If flg.resumenext = "Y" Then
    flg.resumenext = "N"
'    Resume Next
  Else
    flg.error = "N"
'    Resume
  End If
End Sub

Public Function btrim$(arg$)
  btrim$ = LTrim$(RTrim$(arg$))
End Function

' Configuration file parser routines.
'
' (c) Copyright 1993 - 2011 Mark Hobley
'
' This configuration parser contains code ported from an application program
' written in Microsoft Quickbasic
'
' This code can be redistributed or modified under the terms of version 1.2 of
' the GNU Free Documentation Licence as published by the Free Software Foundation.

Sub readini()
  var.filename = btrim$(var.winpath) & ini.inifile
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
  var.inistream = var.stream
readinilabela:
  Call readlinefromfile
  If flg.error = "Y" Then
    flg.abort = "Y"
    Call closestream
    flg.error = "Y"
    Exit Sub
  End If
  If flg.endoffile <> "Y" Then
    iniline$ = message$
    If iniline$ <> "" Then
      If Left$(iniline$, 1) <> ini.commentchar AND Left$(iniline$, 1) <> ini.ignorechar Then
        endofinicommand% = 0
        For l% = 1 To Len(iniline$)
          If Mid$(iniline$, l%, 1) < " " Then
            endofinicommand% = l%
          End If
          If Not (endofinicommand%) Then
            If Mid$(iniline$, l%, 1) = " " Then
              endofinicommand% = l%
            End If
          End If
          If endofinicommand% Then
            l% = Len(iniline$)
          End If
        Next l%
        iniarg$ = ""
        If endofinicommand% Then
          If endofinicommand% <> Len(iniline$) Then
            iniarg$ = btrim$(Mid$(iniline$, endofinicommand% + 1))
            If iniarg$ = "" Then
              GoTo readinilabelb
            End If
            inicommand$ = Left$(iniline$, endofinicommand% - 1)
          End If
        Else
          inicommand$ = btrim$(iniline$)
        End If
readinilabelb:
        'interpret command
        inicommand$ = UCase$(inicommand$)
        Select Case inicommand$
          Case "FULLNAME"
            If iniarg$ <> "" Then
              ini.fullname = iniarg$
            End If
          Case "FAVOURITEFRUIT"
            If iniarg$ <> "" Then
              ini.favouritefruit = iniarg$
            End If
          Case "NEEDSPEELING"
            ini.needspeeling = "Y"
          Case "SEEDSREMOVED"
            ini.seedsremoved = "Y"
          Case "OTHERFAMILY"
            If iniarg$ <> "" Then
              ini.otherfamily = iniarg$
              CALL familyparser
            End If
          Case Else
            '!! error handling required
        End Select
      End If
    End If
    GoTo readinilabela
  End If
  Call closestream
  Exit Sub
readinierror:

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

Sub readlinefromfile()
  If ini.errortrap = "Y" Then
    On Local Error GoTo readlinefromfileerror
  End If
  If EOF(var.stream) Then
    flg.endoffile = "Y"
    Exit Sub
  End If
  Line Input #var.stream, tmp$
  message$ = tmp$
  Exit Sub
readlinefromfileerror:
  var.errorcode = Err
  Call errorhandler
  resume '!!
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

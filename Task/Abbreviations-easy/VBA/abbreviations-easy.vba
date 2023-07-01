Private Function ValidateUserWords(userstring As String) As String
    Dim s As String
    Dim user_words() As String
    Dim command_table As Scripting.Dictionary
    Set command_table = New Scripting.Dictionary
    Dim abbreviations As Scripting.Dictionary
    Set abbreviations = New Scripting.Dictionary
    abbreviations.CompareMode = TextCompare
    Dim commandtable() As String
    Dim commands As String
    s = s & "Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy "
    s = s & "COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find "
    s = s & "NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput "
    s = s & "Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO "
    s = s & "MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT "
    s = s & "READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT "
    s = s & "RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up "
    commandtable = Split(s, " ")
    Dim i As Integer
    For Each word In commandtable
        If Len(word) > 0 Then
            i = 1
            Do While Mid(word, i, 1) >= "A" And Mid(word, i, 1) <= "Z"
                i = i + 1
            Loop
            command_table.Add Key:=word, Item:=i - 1
        End If
    Next word
    For Each word In command_table
        For i = command_table(word) To Len(word)
            On Error Resume Next
            abbreviations.Add Key:=Left(word, i), Item:=UCase(word)
        Next i
    Next word
    user_words() = Split(userstring, " ")
    For Each word In user_words
        If Len(word) > 0 Then
            If abbreviations.exists(word) Then
                commands = commands & abbreviations(word) & " "
            Else
                commands = commands & "*error* "
            End If
        End If
    Next word
    ValidateUserWords = commands
End Function
Public Sub program()
    Dim guserstring As String
    guserstring = "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin"
    Debug.Print "user words:", guserstring
    Debug.Print "full words:", ValidateUserWords(guserstring)
End Sub

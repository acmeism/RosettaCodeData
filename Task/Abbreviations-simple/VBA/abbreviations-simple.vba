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
    s = s & "add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3 "
    s = s & "compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate "
    s = s & "3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2 "
    s = s & "forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load "
    s = s & "locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2 "
    s = s & "msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3 "
    s = s & "refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left "
    s = s & "2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1 "
    commandtable = Split(s, " ")
    Dim i As Integer, word As Variant, number As Integer
    For i = LBound(commandtable) To UBound(commandtable)
        word = commandtable(i)
        If Len(word) > 0 Then
            i = i + 1
            Do While Len(commandtable(i)) = 0: i = i + 1: Loop
            number = Val(commandtable(i))
            If number > 0 Then
                command_table.Add Key:=word, Item:=number
            Else
                command_table.Add Key:=word, Item:=Len(word)
                i = i - 1
            End If
        End If
    Next i
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

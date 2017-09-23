EnableExplicit
#LETTERS = "BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM "

Procedure.s can_make_word(word.s)
  Define letters.s = #LETTERS, buffer.s
  Define index1.i, index2.i
  Define match.b
  For index1=1 To Len(word)
    index2=1 : match=#False
    Repeat
      buffer=StringField(letters,index2,Space(1))
      If FindString(buffer,Mid(word,index1,1),1,#PB_String_NoCase)
        letters=RemoveString(letters,buffer+Chr(32),0,1,1)
        match=#True
        Break
      EndIf
      index2+1
    Until index2>CountString(letters,Space(1))
    If Not match : ProcedureReturn word+#TAB$+"FALSE" : EndIf
  Next
  ProcedureReturn word+#TAB$+"TRUE"
EndProcedure

OpenConsole()
PrintN(can_make_word("a"))
PrintN(can_make_word("BaRK"))
PrintN(can_make_word("BOoK"))
PrintN(can_make_word("TREAt"))
PrintN(can_make_word("cOMMON"))
PrintN(can_make_word("SqUAD"))
PrintN(can_make_word("COnFUSE"))
Input()

#LETTERS = "BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM "

Macro test(t)
  Print(t+#TAB$+#TAB$+"= ") : If can_make_word(t) : PrintN("True") : Else : PrintN("False") : EndIf
EndMacro

Procedure.s residue(s$,n.i)
  ProcedureReturn Left(s$,Int(n/3)*3)+Mid(s$,Int(n/3)*3+4)
EndProcedure

Procedure.b can_make_word(word$,letters$=#LETTERS)
  n=FindString(letters$,Left(word$,1),1,#PB_String_NoCase)
  If Len(word$) And n : ProcedureReturn can_make_word(Mid(word$,2),residue(letters$,n)) : EndIf
  If Not Len(word$)   : ProcedureReturn #True : Else : ProcedureReturn #False           : EndIf
EndProcedure

OpenConsole()
test("a")         : test("BaRK")      : test("BOoK")      : test("TREAt")
test("cOMMON")    : test("SqUAD")     : test("COnFUSE")
Input()

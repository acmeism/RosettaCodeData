#NoEnv
#SingleInstance, force
				; press Esc to stop and display the output text
				; (a debug file describing ongoing steps will be created in the end)
FileEncoding, UTF-8
FileRead, warWords, war of words.txt   ; wrapped booktext
global textOut := " "
global warWords := strreplace(warWords,"`r`n", " ")
warWords := strreplace(warWords,"`r", " ")
warWords := strreplace(warWords,"`n", " ")
warWords := strreplace(warWords,"-", " ")
warWords := strreplace(warWords,"—", " ")
warWords := strreplace(warWords,"`t", " ")
warWords := strreplace(warWords,"“")
warWords := strreplace(warWords,"_")
warWords := strreplace(warWords,"”")
warWords := strreplace(warWords,"’")
warWords := strreplace(warWords,"'")
warWords := strreplace(warWords,"""")
warWords := strreplace(warWords,")")
warWords := strreplace(warWords,"(")
warWords := strreplace(warWords,"[")
warWords := strreplace(warWords,"]")
warWords := strreplace(warWords,"{")
warWords := strreplace(warWords,"}")
warWords := strreplace(warWords,"»")
warWords := strreplace(warWords,"«")
warWords := trim(warWords)
Loop
{
	warWords := strreplace(warWords,"  ", " ")
	if (Errorlevel = 0)
		break
}
FileDelete, debug.txt
InputBox, fOne, War of Words, Choice a punctuation to start ( . or ! or ? or `, ),,,,,,,,.
treco := NextPunct(fOne)
Loop
{
loop,parse,treco," "
	if A_LoopField
		fOne := trim(A_LoopField)
textOut .= fOne . " "
tremPos := InStr(textOut," ",,0,3)
tremText := trim(substr(textOut,tremPos))
if tremText
	{
		tremText := strreplace(tremText,".","\.")
		tremText := strreplace(tremText,";","\;")
		tremText := strreplace(tremText,",","\,")
		tremText := strreplace(tremText,"!","\!")
		tremText := " " . strreplace(tremText,"?","\?")
		treco := NextWord(tremText)
	}
else
	treco := NextWord(fOne)
}

NextPunct(punct) {
xpos := 1
prox := []
Loop
{
	spos := RegExMatch(warWords, "(*UCP)\" . punct . " \w+.",gg,xpos)
	if (spos = 0)
		break
	prox[a_index] := gg
	xpos := spos + 1
}
proximas := ""
loop, % prox.MaxIndex()
	proximas .= a_index . " -> " . prox[a_index] . "`n"
FileAppend, %proximas%, debug.txt, UTF-8
Random, linha, 1, prox.MaxIndex()
FileAppend, % "---------------`nescolhido = " . linha . " -> " . prox[linha] . " -> " . textOut . "`n----------------`n", debug.txt, UTF-8
return prox[linha]
}

NextWord(word) {
xpos := 1
prox := []
loop
{
	spos := RegExMatch(warWords, "(*UCP)" . word . " \w+.",gg,xpos)
	if !spos
		break
	prox[a_index] := gg
	xpos := spos + 1
}

if (prox.MaxIndex() > 0)
{
proximas := ""
loop, % prox.MaxIndex()
	proximas .= a_index . " -> " . prox[a_index] . "`n"
FileAppend, %proximas%, debug.txt, UTF-8
Random, linha, 1, prox.MaxIndex()
FileAppend, % "---------------`nescolhido = " . linha . " -> " . prox[linha] . " -> " . textOut . "`n----------------`n", debug.txt, UTF-8
return % prox[linha]
}	

loop,parse,word," "
	wrd := A_LoopField
word := wrd
spos := xpos := 1
prox := []
loop
{
	spos := RegExMatch(warWords, "(*UCP)" . word . " \w+.",gg,xpos)
	if (spos = 0)
		break
	prox[a_index] := gg
	xpos := spos + 1
}
proximas := ""
loop, % prox.MaxIndex()
	proximas .= a_index . " -> " . prox[a_index] . "`n"
FileAppend, %proximas%, debug.txt, UTF-8
Random, linha, 1, prox.MaxIndex()
FileAppend, % "---------------`nescolhido = " . linha . " -> " . prox[linha] . " -> " . textOut . "`n----------------`n", debug.txt, UTF-8
return % prox[linha]
}

ExitApp

~Esc::
msgbox % textOut . "..."
ExitApp

; Setting up command table as one string
str =
(
 Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy
 COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
 NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
 Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO
 MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT
 READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT
 RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up
)
str := StrReplace(str,"`n")

; comTable turns the command table string into an array
; comTableCapsCount creates an array with the count of capital values for each word
comTable := StrSplit(RegExReplace(str, "\s+", " "), " ")
comTableCapsCount := []
for cmds in comTable
	comTableCapsCount.push(StrLen(RegExReplace(comTable[cmds], "[a-z]")))

; Take and process user input into an array of abbreviations
InputBox, abbrev, Command, Type in your command(s).`n If you have several commands`, leave spaces between them.
abbrev := Trim(abbrev)
StringLower, lowerCaseAbbrev, abbrev
abbrev := StrSplit(RegExReplace(abbrev, "\s+", " "), " ")

; Double loop compares abbreviations to commands in command table
Loop % abbrev.MaxIndex() {
	count := A_Index
	found := false
	for cmds in comTable {
		command := SubStr(comTable[cmds], 1, StrLen(abbrev[count]))
		StringLower, lowerCaseCommand, command
		if (lowerCaseCommand = abbrev[count]) and (StrLen(abbrev[count]) >= comTableCapsCount[cmds]) {
			StringUpper, foundCmd, % comTable[cmds]
			found := true
		}
	}
	if (found)
		result .= " " foundCmd
	else
		result .= " *error*"
}
MsgBox % Trim(result)

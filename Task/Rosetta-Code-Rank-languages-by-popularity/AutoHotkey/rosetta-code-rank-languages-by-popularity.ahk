MembsUrl = http://rosettacode.org/mw/index.php?title=Special:Categories&limit=5000
ValidUrl = http://rosettacode.org/wiki/Category:Programming_Languages
WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")

; Get the webpages
WebRequest.Open("GET", MembsUrl),WebRequest.Send()
MembsPage := WebRequest.ResponseText
WebRequest.Open("GET", ValidUrl),WebRequest.Send()
ValidPage := WebRequest.ResponseText

; Replace special characters
StringReplace, MembsPage, MembsPage, ΜC++, µC++, All
StringReplace, MembsPage, MembsPage, МК-61/52, MK-61/52, All
StringReplace, ValidPage, ValidPage, ΜC++, µC++, All
StringReplace, ValidPage, ValidPage, МК-61/52, MK-61/52, All

ValidREx := "s)href=""([^""]+)"" title=""Category:([^""]+)"">(?=.*</table>)"
MembsREx := "title=""Category:(.+?)"">.+?\((\d+) members?\)"

; Iterate through all matches for valid languages
ValidLangs := [], FoundPos := 0
While FoundPos := RegExMatch(ValidPage, ValidREx, Match, FoundPos+1)
	ValidLangs[Match2] := Match1

; Iterate through all matches for categories with members
MembsLangs := [], Dupes := [], Detected := 0, FoundPos := 0
While FoundPos := RegExMatch(MembsPage, MembsREx, Match, FoundPos+1)
{
	; If it isn't a valid language or is a duplicate, skip it
	if !ValidLangs.HasKey(Match1) || Dupes.HasKey(Match1)
		continue
	
	Dupes.Insert(Match1, true)
	Detected++
	
	; Initialize this member count
	if !IsObject(MembsLangs[Match2])
		MembsLangs[Match2] := [Match1]
	else
		MembsLangs[Match2].Insert(Match1)
}

; Sort the languages with the highest member count first
Sorted := []
for Members, Languages in MembsLangs
	Sorted.Insert(1, [Members, Languages])

; Initialize the GUI
Gui, New, HwndGuiHwnd
Gui, Add, Text, w300 Center, %Detected% languages detected
Gui, Add, Edit, w300 vSearchText gSearch, Filter languages
Gui, Add, ListView, w300 r20 Grid gOpen vMyListView, Rank|Members|Category

; Populate the list view
LV_ModifyCol(1, "Integer"), LV_ModifyCol(2, "Integer"), LV_ModifyCol(3, 186)
for Rank, Languages in Sorted
	for Key, Language in Languages[2]
		LV_Add("", Rank, Languages[1], Language)

Gui, Show,, Rosetta Code
return

Open:
if (A_GuiEvent == "DoubleClick")
{
	LV_GetText(Language, A_EventInfo, 3)
	Run, % "http://rosettacode.org" ValidLangs[Language]
}
return

Search:
GuiControlGet, SearchText
GuiControl, -Redraw, MyListView

LV_Delete()
for Rank, Languages in Sorted
	for Key, Language in Languages[2]
		if InStr(Language, SearchText)
			LV_Add("", Rank, Languages[1], Language)

GuiControl, +Redraw, MyListView
return

GuiClose:
ExitApp
return

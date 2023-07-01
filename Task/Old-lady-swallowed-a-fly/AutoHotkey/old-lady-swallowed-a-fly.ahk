Animals := [["fly",	"I don't know why she swallowed the "]
	  , ["spider",	"That wriggled and jiggled and tickled inside her"]
	  , ["bird",	"Quite absurd"]
	  , ["cat",	"Fancy that"]
	  , ["dog",	"What a hog"]
	  , ["pig",	"Her mouth was so big"]
	  , ["goat",	"She just opened her throat"]
	  , ["cow",	"I don't know how"]
	  , ["donkey",	"It was rather wonky"]
	  , ["horse",	"She's dead, of course!"]]

for i, V in Animals {
	Output .= "I know an old lady who swallowed a " V.1 ".`n"
	. (i = 1 ? Saved := V.2 V.1 ".`nPerhaps she'll die.`n`n"
	: V.2 (i = Animals.MaxIndex() ? "" : (i = 2 ? "" : ". To swallow a " V.1) ".`n"
	. (Saved := "She swallowed the " V.1 " to catch the " Animals[i - 1].1 ".`n" Saved)))
}

MsgBox, % Output

m := (FillInTheBlankMorph request: 'Number of rows?') asNumber.
n := (FillInTheBlankMorph request: 'Number of columns?') asNumber.
aMatrix := Matrix rows: m columns: n.
aMatrix
	at: (aMatrix rowCount // 2)
	at: (aMatrix columnCount // 2)
	put: 3.4.
e := aMatrix
	at: (aMatrix rowCount // 2)
	at: (aMatrix columnCount // 2).
Transcript show: 'Entry is', e printString.

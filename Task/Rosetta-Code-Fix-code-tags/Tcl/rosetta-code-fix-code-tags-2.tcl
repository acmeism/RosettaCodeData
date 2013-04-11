set text [regexp -all "<([join $langs |])>" $text {<lang \1>}]
set text [regexp -all "</(?:[join $langs |])>" $text "<$slang>"]

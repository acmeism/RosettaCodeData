-- Bog-standard AppleScript global-search-and-replace handler.
-- searchText can be either a single string or a list of strings to be replaced with replacementText.
on replace(mainText, searchText, replacementText)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to searchText
    set textItems to mainText's text items
    set AppleScript's text item delimiters to replacementText
    set editedText to textItems as text
    set AppleScript's text item delimiters to astid

    return editedText
end replace

-- Demo:
set txt to "The quick brown fox jumps over the lazy dog
L'œuvre d'un élève
van Dĳk
\"The Death of Åse\"
São Paulo    Győr    Malmö    Mjøsa
Jiří Bělohlávek conducts Martinů
Po co pan tak brzęczy w gąszczu?
Mahādeva"

ignoring diacriticals and case
    set devowelledText to replace(txt, {"a", "e", "i", "o", "u"}, "")
end ignoring
return devowelledText

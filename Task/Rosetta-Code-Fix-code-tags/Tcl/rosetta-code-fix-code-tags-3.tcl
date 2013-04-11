set replacements [list </code> <$slang>]
foreach lang $langs {
    lappend replacements "<$lang>" "<lang $lang>"
    lappend replacements "</$lang>" "<$slang>"
    lappend replacements "<code $lang>" "<lang $lang>"
}
set text [string map $replacements $text]

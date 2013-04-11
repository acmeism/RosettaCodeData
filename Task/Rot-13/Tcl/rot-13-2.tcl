package require Tclx
proc rot13 str {
    translit "A-Za-z" "N-ZA-Mn-za-m" $str
}

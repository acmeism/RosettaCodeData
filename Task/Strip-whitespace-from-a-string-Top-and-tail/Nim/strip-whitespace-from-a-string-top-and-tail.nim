import strutils

let s = " \t \n String with spaces  \t  \n  "
echo "'", s, "'"
echo "'", s.strip(trailing = false), "'"
echo "'", s.strip(leading = false), "'"
echo "'", s.strip(), "'"

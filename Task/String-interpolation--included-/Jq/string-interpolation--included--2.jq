$ jq -M -n -r '"Jürgen" as $x | "The string \"\($x)\" has \($x|length) codepoints."'
The string "Jürgen" has 6 codepoints.

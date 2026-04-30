# standard switch
switch ($var) {
    1 { "Value was 1" }
    2 { "Value was 2" }
    default { "Value was something else" }
}

# switch with wildcard matching
switch -Wildcard ($var) {
    "a*" { "Started with a" }
    "*x" { "Ended with x" }
}

# switch with regular expression matching
switch -Regex ($var) {
    "[aeiou]" { "Contained a consonant" }
    "(.)\1" { "Contained a character twice in a row" }
}

# switch allows for scriptblocks too
switch ($var) {
    { $_ % 2 -eq 0 } { "Number was even" }
    { $_ -gt 100 }   { "Number was greater than 100" }
}

# switch allows for handling a file
switch -Regex -File somefile.txt {
    "\d+" { "Line started with a number" }
    "\s+" { "Line started with whitespace" }
}

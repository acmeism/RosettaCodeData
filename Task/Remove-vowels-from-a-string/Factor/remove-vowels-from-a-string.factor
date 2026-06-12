USING: formatting kernel sets ;

: without-vowels ( str -- new-str ) "aeiouAEIOU" without ;

"Factor Programming Language" dup without-vowels
"  Input string: %s\nWithout vowels: %s\n" printf

marker foo
: temp  ... ;
create dummy 300 allot
-150 allot      \ trim the size of dummy by 150 bytes
foo    \ removes foo, temp, and dummy from the list of definitions

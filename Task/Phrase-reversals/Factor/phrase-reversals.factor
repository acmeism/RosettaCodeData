USE: splitting

: splitp         ( str -- seq ) " " split ;
: printp         ( seq -- )     " " join print ;
: reverse-string ( str -- )     reverse print ;
: reverse-words  ( str -- )     splitp [ reverse ] map printp ;
: reverse-phrase ( str -- )     splitp reverse printp ;

"rosetta code phrase reversal" [ reverse-string ] [ reverse-words ] [ reverse-phrase ] tri

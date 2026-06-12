/*REXX programs displays the text between two text deliminiters in a target text string.*/
call TB 'Hello Rosetta Code world', "Hello ",   ' world'
call TB 'Hello Rosetta Code world', "start",    ' world'
call TB 'Hello Rosetta Code world', "Hello",    'end'
call TB '</div><div style=\"chinese\">???</div>', '<div style=\"chinese\">', "</div>"
call TB '<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">',"<text>",'<table>'
call TB '<table style=\"myTable\"><tr><td>hello world</td></tr></table>',"<table>",'</table>'
call TB 'The quick brown fox jumps over the lazy other fox', "quick ", ' fox'
call TB 'One fish two fish red fish blue fish',              "fish ",  ' red'
call TB 'FooBarBazFooBuxQuux',  "Foo",   'Foo'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
TB: procedure: parse arg T,S,E;      say         /*obtain text, start delim, end delim. */
    say '           Text: "'T'"'                 /*echo the  text          to terminal. */
    say 'Start delimiter: "'S'"'                 /*  "   "   start delim    "    "      */
    say 'End   delimiter: "'E'"'                 /*  "   "    end    "      "    "      */
    $=T;  if S\=='start'  then parse var T (S) $ /*extract stuff  after  the START delim*/
          if E\=='end'    then parse var $ $ (E) /*   "      "   before   "   END.   "  */
    say '         Output: "'$'"'                 /*display the extracted string to term.*/
    return

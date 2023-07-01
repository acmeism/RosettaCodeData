require'format/printf'  NB.  For formatting the output
'C I' =: <"1 |: P =: ; ;"0 1^:(0<#@[)&.>/"1 (({.~ ; (}.~>:)) i.&'|')&> LF cut noun define
|
-|"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln
7|..1111111111111111111111111111111111111111111111111111111111111117777888
.|I never give 'em hell, I just tell the truth, and they think it's hell.
 -r|                                                    --- Harry S Truman
)
S =: sq&.>/"1 P
smoutput 'chr: ''%s''\nin:  %d «««%s»»»\nout: %d «««%s»»»\n' sprintf C ,. (#&.>I),.I ,. (#&.>S),.S

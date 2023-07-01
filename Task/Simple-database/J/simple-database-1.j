HELP=: 0 :0
Commands:

DBNAME add DATA
DBNAME display the latest entry
DBNAME display the latest entry where CATEGORY contains WORD
DBNAME display all entries
DBNAME display all entries order by CATEGORY

1) The first add with new DBNAME assign category names.
2) lower case arguments verbatim.
3) UPPER CASE: substitute your values.

Examples, having saved this program as a file named s :
$ jconsole s simple.db display all entries
$ jconsole s simple.db add "first field" "2nd field"
)

Q=: ''''                                NB. quote character
time=: 6!:0@:('YYYY-MM-DD:hh:mm:ss.sss'"_)

embed=: >@:{.@:[ , ] , >@:{:@:[
assert '(x+y)' -: '()' embed 'x+y'

Duplicate=: 1 :'#~ m&= + 1 #~ #'
assert 0 1 2 3 3 4 -: 3 Duplicate i.5

prepare=: LF ,~ [: }:@:; (Q;Q,';')&embed@:(Q Duplicate)&.>@:(;~ time)
assert (-: }.@:".@:}:@:prepare) 'boxed';'';'li''st';'of';'''strings'''

categorize=: dyad define
i=. x i. y
if. (1 (~: #) i) +. i (= #) x do.
 smoutput 'choose 1 of'
 smoutput x
 exit 1
end.
{. i                                  NB. "index of" frame has rank 1.
)
assert 0 -: 'abc' categorize 'a'

loadsdb=: (<'time') (<0 0)} ".;._2@:(1!:1)

Dispatch=: conjunction define
help
:
commands=. y
command=. {. commands
x (u`help@.(command(i.~ ;:)n)) }.commands
)

NB. the long fork in show groups (": #~ (1 1 embed (1j1 }:@:# (1 #~ #))))
show=: smoutput@:(": #~ 1 1 embed 1j1 }:@:# 1 #~ #)

in=: +./@:E.
assert 'the'    in'quick brown fox jumps over the lazy dog'
assert 'the'-.@:in'QUICK BROWN FOX JUMPS OVER THE LAZY DOG'

where=: dyad define
'category contains word'=. 3 {. y
if. 'contains' -.@:-: contains do.
 help''
 exit 1
end.
i=. x ({.@:[ categorize <@:]) category
j=. {: I. ; word&in&.> i {"1 x
if. 0 (= #) j do.
 smoutput 'no matches'
else.
 x (show@:{~ 0&,) j
end.
)

entry=: 4 : 0
if. a: = y do.
 show@:({. ,: {:) x
else.
 x ''`where Dispatch'where' y
end.
)

latest=: ''`entry Dispatch'entry'
the=: ''`latest Dispatch'latest'

by=: 4 : 0
i=. x (categorize~ {.)~ y
show ({. , (/: i&{"1)@:}.) x
)

order=: ''`by Dispatch'by'

entries=: 4 : 0
if. a: = y do.
 show x
else.
 x ''`order Dispatch'order' y
end.
)

all=: ''`entries Dispatch'entries'

help=: smoutput@:(HELP"_)
add=: 1!:3~ prepare                     NB. minimal---no error tests
display=: (the`all Dispatch'the all'~ loadsdb)~  NB. load the simple db for some sort of display

({. add`display Dispatch'add display' }.)@:(2&}.)ARGV

exit 0

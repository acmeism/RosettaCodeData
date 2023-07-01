NB.               character classes:
NB. 0: whitespace
NB. 1: "
NB. 2: \
NB. 3: [ ] , { } :
NB. 4: ordinary
classes=.3<. '"\[],{}:' (#@[ |&>: i.) a.
classes=.0 (I.a.e.' ',CRLF,TAB)} (]+4*0=])classes

words=:(0;(0 10#:10*".;._2]0 :0);classes)&;: NB. states:
  0.0  1.1  2.1  3.1  4.1  NB. 0 whitespace
  1.0  5.0  6.0  1.0  1.0  NB. 1 "
  4.0  4.0  4.0  4.0  4.0  NB. 2 \
  0.3  1.2  2.2  3.2  4.2  NB. 3 { : , } [ ]
  0.3  1.2  2.0  3.2  4.0  NB. 4 ordinary
  0.3  1.2  2.2  3.2  4.2  NB. 5 ""
  1.0  1.0  1.0  1.0  1.0  NB. 6 "\
)

tokens=. ;:'[ ] , { } :'
actions=: lBra`rBracket`comma`lBra`rBrace`colon`value

NB. action verbs argument conventions:
NB.   x -- boxed json word
NB.   y -- boxed json state stack
NB.   result -- new boxed json state stack
NB.
NB. json state stack is an list of boxes of incomplete lists
NB. (a single box for complete, syntactically valid json)
jsonParse=: 0 {:: (,a:) ,&.> [: actions@.(tokens&i.@[)/ [:|.a:,words

lBra=: a: ,~ ]
rBracket=: _2&}.@], [:< _2&{::@], _1&{@]
comma=: ]
rBrace=: _2&}.@], [:< _2&{::@](, <)  [:|: (2,~ [: -:@$ _1&{::@]) $ _1&{::@]
colon=: ]
value=: _1&}.@], [:< _1&{::@], jsonValue&.>@[

NB. hypothetically, jsonValue should strip double quotes
NB. interpret back slashes
NB. and recognize numbers
jsonValue=:]


require'strings'
jsonSer2=: jsonSer1@(<"_1^:(0>.#@$-1:))
jsonSer1=: ']' ,~ '[' }:@;@; (',' ,~ jsonSerialize)&.>
jsonSer0=: '"', jsonEsc@:":, '"'"_
jsonEsc=: rplc&(<;._1' \ \\ " \"')
jsonSerialize=:jsonSer0`jsonSer2@.(*@L.)

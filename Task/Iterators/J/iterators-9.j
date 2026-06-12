nextItem=: {{ (x+1) -.#y }}
nextLink=: {{ (1;x) #~ (L.y) > #x }}

makeIterator=: {{ x;y;0 }}

iterate=: {{'`next val more'=. ops['ops list position'=. y
  (}:y),<position next list
}}

value=: {{'`next val more'=. ops['ops list position'=. y
  position val list
}}

more=: {{'`next val more'=. ops['ops list position'=. y
  more position
}}

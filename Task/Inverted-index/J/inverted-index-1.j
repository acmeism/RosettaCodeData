require'files regex strings'

rxutf8 0  NB. support latin1 searches for this example, instead of utf8
files=:words=:buckets=:''
wordre=: rxcomp '[\w'']+'
parse=: ,@:rxfrom~ wordre&rxmatches

invert=: verb define
  files=: files,todo=. ~.y-.files
  >invert1 each todo
)

invert1=: verb define
  file=. files i.<y
  words=: ~.words,contents=. ~.parse tolower fread jpath y
  ind=. words i. contents
  buckets=: buckets,(1+words -&# buckets)#a:
  #buckets=: (file,~each ind{buckets) ind}buckets
)

search=: verb define
  hits=. buckets{~words i.~.parse tolower y
  files {~ >([-.-.)each/hits
)

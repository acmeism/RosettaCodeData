competitors=:<;._1;._2]0 :0
 44 Solomon
 42 Jason
 42 Errol
 41 Garry
 41 Bernard
 41 Barry
 39 Stephen
)

scores=:  {."1

standard=: 1+i.~
modified=: 1+i:~
dense=: #/.~ # #\@~.
ordinal=: #\
fractional=: #/.~ # ] (+/%#)/. #\

rank=:1 :'<"0@u@:scores,.]'

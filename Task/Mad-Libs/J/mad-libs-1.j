require 'general/misc/prompt regex'

madlib=:3 :0
  smoutput 'Please enter the story template'
  smoutput 'See http://rosettacode.org/wiki/Mad_Libs for details'
  t=.''
  while.#l=.prompt '' do. t=.t,l,LF end.
  repl=. ~.'<[^<>]*>' rxall t
  for_bef. repl do.
    aft=. prompt (}.}:;bef),': '
    t=.t rplc bef,<aft
  end.
  t
)

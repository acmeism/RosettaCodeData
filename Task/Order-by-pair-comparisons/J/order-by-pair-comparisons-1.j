require'general/misc/prompt'
sel=: {{ u#[ }}

quicksort=: {{
 if. 1 >: #y do. y
 else.
  (u quicksort y u sel e),(y =sel e),u quicksort y u~ sel e=.y{~?#y
 end.
}}

ptc=: {{
  t=. (+. +./ .*.~)^:_ y=1
  j=. I.,t+.|:t
  ($y)$(j{,t) j} ,y
}}

askless=: {{
   coord=. x ,&(items&i.) y
   lt=. LT {~<coord
   if. 1<lt do.
     lt=. 'y' e. tolower prompt 'Is ',(":;x),' less than ',(":;y),'? '
     LT=: ptc (lt,-.lt) (coord;|.coord)} LT
   end.
   lt
}}"0

asksort=: {{
  items=: ~.y
  LT=: <:%=i.#items
  askless quicksort y
}}

brtr=:4 :0
  seed=. ?x
  clip=. 0 >. (<:x) <."1 ]
  near=. [: clip +"1/&(,"0/~i:1)
  p=.i.0 2
  mask=. 1 (<"1 near seed)} x$0
  field=.1 (<seed)} x$0
  for.i.y do.
    p=. clip (p +"1 <:?3$~$p),?x
    b=.(<"1 p) { mask
    fix=. b#p
    if.#fix do. NB. if. works around j602 bug: 0(0#a:)}i.0 0
      p=. (-.b)# p
      mask=. 1 (<"1 near fix)} mask
      field=. 1 (<"1 fix)} field
    end.
  end.
  field
)

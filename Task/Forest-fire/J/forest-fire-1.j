NB. states: 0 empty, 1 tree, _1 fire
dims =:10 10

  tessellate=: 0,0,~0,.0,.~ 3 3 >./@,;._3 ]
  mask=: tessellate dims$1
  chance=: 1 :'(> ? bind (dims$0)) bind (mask*m)'

start=: 0.5 chance
grow =: 0.01 chance
fire =: 0.001 chance

  spread=: [: tessellate 0&>

  step=: grow [`]@.(|@])"0 >.&0 * _1 ^ fire +. spread

  run=:3 :0
    forest=. start''
    for.i.y do.
      smoutput ' #o' {~ forest=. step forest
    end.
  )

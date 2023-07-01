wheelgroup=:{{
  yield_wheelgroup_=: {{
    i=. wheels i.<;y
    j=. i{inds
    k=. ".;y
    l=. j{k
    inds=: ((#k)|1+j) i} inds
    if. l e. wheels
    do.yield l
    else.{.".;l
    end.
  }}
  gen_wheelgroup_=: {{
    yield wheel
  }}
  grp=. cocreate ''
  coinsert__grp 'wheelgroup'
  specs__grp=: cut each boxopen m
  wheel__grp=: ;{.wheels__grp=: {.every specs__grp
  init__grp=: {{('inds';wheels)=:(0#~#specs);}.each specs}}
  init__grp''
  ('gen_',(;grp),'_')~
}}

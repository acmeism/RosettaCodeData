dataorder=: /:@data reorder ]
levelorder=: /:@depth@parent reorder ]

inorder=: inperm@parent reorder ]
inperm=:3 :0
  chil=. childinds y
  node=. {.I.(= i.@#) y
  todo=. i.0 2
  r=. i.0
  whilst. (#todo)+.0<:node do.
    if. 0 <: node do.
      if. 0 <: {.ch=. node{chil do.
        todo=. todo, node,{:ch
        node=. {.ch
      else.
        r=. r, node
        node=. _1 end.
    else.
      r=. r, {.ch=. {: todo
      todo=. }: todo
      node=. {:ch end. end.
  r
)

postorder=: postperm@parent reorder ]
postperm=:3 :0
  chil=. 0,1+childinds y
  todo=. 1+I.(= i.@#) y
  r=. i.0
  whilst. (#todo) do.
    node=. {: todo
    todo=. }: todo
    if. 0 < node do.
      if. #ch=. (node{chil)-.0 do.
        todo=. todo,(-node),|.ch
      else.
        r=. r, <:node end.
    else.
      r=. r, <:|node  end. end.
)

preorder=: preperm@parent reorder ]
preperm=:3 :0
  chil=. childinds y
  todo=. I.(= i.@#) y
  r=. i.0
  whilst. (#todo) do.
    r=. r,node=. {: todo
    todo=. }: todo
    if. #ch=. (node{chil)-._1 do.
      todo=. todo,|.ch end. end.
  r
)

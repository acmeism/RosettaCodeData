vertices=: ;:'a b c d e f'
edges=:|: ;:;._2]0 :0
  a b 7
  a c 9
  a f 14
  b c 10
  b d 15
  c d 11
  c f 2
  d e 6
  e f 9
)

shortest_path=:1 :0
:
  NB. x: path endpoints, m: vertex labels, y: edges (starts,ends,:costs)
  terminals=. m i. x
  starts=. m i. 0{y
  ends=.   m i. 1{y
  tolls=.  _&".@> 2{y
  C=. tolls (starts,&.>ends)}_$~2##m
  bestprice=. (<terminals){ (<. <./ .+/~)^:_ C
  best=. i.0
  if. _>bestprice do.
    paths=. ,.{.terminals
    goal=. {:terminals
    costs=. ,0
    while. #costs do.
      next=. ({:paths){C
      keep=. (_>next)*bestprice>:next+costs
      rep=. +/"1 keep
      paths=. (rep#"1 paths),(#m)|I.,keep
      costs=. (rep#"1 costs)+keep #&, next
      if. #j=. I. goal = {:paths do.
        best=. best, (bestprice=j{costs)# <"1 j{|:paths
      end.
      toss=. <<<j,I.bestprice<:costs
      paths=. toss {"1 paths
      costs=. toss { costs
    end.
  end.
  best {L:0 _ m
)

floyd=: {{for_j.i.#y do. y=. y<.j({"1+/{) y end.}}
cells=: I.,0<:,map
pairs=: cells i.;<@(($map) #. plan)"_1 ($map)#:,.I.0<,map
graph=: floyd 1 (<"1 pairs)} (,~#cells)$_

floydpaths=: {{
  start=: cells i. ($map)#.x
  end=: cells i. ($map)#.y
  distance=: (<start,end){graph
  if. _ = distance do. EMPTY end.
  paths=: ,:start
  targets=: end{"1 graph
  for_d. }:i.-distance do.
    viable=: I.d=targets
    paths=.; <@{{
      p=. plan&.(($map)&#:)&.({&cells) y
      p#~ ({:"_1 p) e. viable
    }}"1 paths
  end.
  ($map)#:cells {~paths,.end
}}

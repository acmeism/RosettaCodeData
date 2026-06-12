blocks=: 0,(|.@|:)^:(i.4)0,1 1 1,:0 1 0
wfc=: {{
  adj=: y#.y|"1(y#:,i.y)+"1/<:3 3#:1 3 5 7
  horz=: ({."1 -:"1/ {:"1) m NB. horizontal tile pairs
  vert=: ({."2 -:"1/ {:"2) m NB. vertical tile pairs
  north=: 1,~|:vert  NB. adj 1 constraint
  south=: 1,~vert    NB. adj 7 constraint
  west=:  1,~|:horz  NB. adj 3 constrint
  east=:  1,~horz    NB. adj 5 constraint
  allow=: north,west,east,:south
  i=: ,y$_1
  while. #todo=: I._1=i do.
    wave=: */"2 ((todo{adj){i){"0 2"1 3 allow
    entropy=: +/"1 wave
    min=: <./ entropy
    if. 0=min do. EMPTY return. end.
    ndx=: ({~ ?@#) I.min=entropy
    i=: (({~?@#)I.ndx{wave) (ndx{todo)} i
  end.
  lap=. {{ y#~(+0=i.@#)-.;m$<n{.1 }}
  ({:y)lap({:$m)"1 ({.y)lap({:$m),/"2,/0 2 1 3|:(y$i){m
}}

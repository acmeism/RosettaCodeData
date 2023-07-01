tarjan=: {{
  coerase ([ cocurrent) cocreate'' NB. following =: declarations are temporary, expiring when we finish
  graph=: y NB. connection matrix of a directed graph
  result=: stack=: i.index=: 0
  undef=: #graph
  lolinks=: indices=: undef"_1 graph
  onstack=: 0"_1 graph
  strongconnect=: {{
    indices=: index y} indices
    lolinks=: index y} lolinks
    onstack=:     1 y} onstack
    stack=: stack,y
    index=: index+1
    for_w. y{::graph do.
      if. undef = w{indices do.
        strongconnect w
        lolinks=: (<./lolinks{~y,w) y} lolinks
      elseif. w{onstack do.
        lolinks=: (<./lolinks{~y,w) y} lolinks
      end.
    end.
    if. lolinks =&(y&{) indices do.
      loc=. stack i. y
      component=. loc }. stack
      onstack=: 0 component} onstack
      result=: result,<component
      stack=: loc {. stack
    end.
  }}
  for_Y. i.#graph do.
    if. undef=Y{indices do.
      strongconnect Y
    end.
  end.
  result
}}

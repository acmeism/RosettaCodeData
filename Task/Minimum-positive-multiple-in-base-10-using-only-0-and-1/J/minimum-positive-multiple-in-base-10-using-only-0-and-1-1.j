B10=: {{ NB. https://oeis.org/A004290
  next=. {{ {: (u -) 10x^# }}
  step=. ([>. [ {~ y|(i.y)+]) next
  continue=. 0 = ({~y|]) next
  L=.1 0,~^:(y>1) (, step)^:continue^:_ ,:y{.1 1
  k=. y|-r=.10x^<:#L
  for_j. i.-<:#L do.
    if. 0=L{~<k,~j-1 do.
      k=. y|k-E=. 10x^j
      r=. r+E
    end.
  end. r assert. 0=y|r
}}

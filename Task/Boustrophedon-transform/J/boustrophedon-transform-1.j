b=: {{
  M=: (u i.y),.(y-0 1)$x:_
  B=:{{
    if. x<y do.0
    else. i=. <x,y
      if. _>i{M do. i{M
      else. r=. (x B y-1)+(x-1) B x-y
        r[M=: r i} M
      end.
    end.
  }}"0
  (<0 1)|:B/~i.y
}}

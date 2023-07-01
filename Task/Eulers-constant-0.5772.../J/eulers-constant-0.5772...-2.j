Euler=: {{
  A=.B=. ^.1r13 1x1
  r=. j=. 0
  whilst. (r=.%/B)~:!.0(r) do.
    B=. B+A=. (j,1)%~+/\.A*169%(1,j)*(j=.j+1)
  end.
  r
}}0

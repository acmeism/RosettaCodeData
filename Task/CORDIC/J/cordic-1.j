epsilon=: 10^-12
phin=: (#~ epsilon <: ])~.@(, _3 o. 10^-@#)^:_ ''
tent=: 10^-i.#phin

cordic=: {{alpha=. y
  XY=. 1 0 assert. 0 <: alpha assert. 0.25p1 >: alpha
  while. epsilon < alpha do.
    k=. phin I. alpha
    alpha=. alpha - k{phin
    XY =. XY + (k{tent) * XY +/ .* ((+.0j1 _1))
  end.
  XY
}}

CORDIC=: {{
  'octant angle'=. 8 0.25p1#:y
  select. octant
    case. 0 do.         cordic        angle
    case. 1 do.       |.cordic 0.25p1-angle
    case. 2 do. _1  1*|.cordic        angle
    case. 3 do. _1  1*  cordic 0.25p1-angle
    case. 4 do. _1 _1*  cordic        angle
    case. 5 do. _1 _1*|.cordic 0.25p1-angle
    case. 6 do.  1 _1*|.cordic        angle
    case. 7 do.  1 _1*  cordic 0.25p1-angle
  end.
}}

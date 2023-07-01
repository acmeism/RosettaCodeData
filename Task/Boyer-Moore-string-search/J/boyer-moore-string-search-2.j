Z=: {{ y {{ 1 i.~y~:(#y){.m }}\.y }}

bmsearch1=: {{
  mx=. <:nx=. #x
  my=. <:ny=. #y
  R=. |:>./\_1,(i.@# ([`]`((256#_1)"0))}&> 3&u:) x
  L=.{{
    j=.I.*y
    j ((#y)-y{~j)} _1#~#y }} Z&.|. x
  F=. >./\.(*]=#-i.@#) Z x
  k=. mx
  k0=. _1
  while. k < ny do.
    i=. mx
    h=. k
    while. (0<:i) * (k0<h) * (i{x) = h{y do.
      i=. i-1
      h=. h-1
    end.
    if. (_1=i)+.k0=h do.
      1+k-nx return.
    else.
      if. mx=i do.
        suffix_shift=. 1
      elseif. _1=L{~i1=. i+1 do.
        suffix_shift=. nx-F{~i1
      else.
        suffix_shift=. mx-L{~i1
      end.
      shift=. suffix_shift >. i-R{~<(3 u: h{y),i
      if. shift > i do. k0=. k end.
      k=. k + shift
    end.
  end.
  EMPTY
}}

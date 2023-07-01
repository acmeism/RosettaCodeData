F=. !P=. p:i.100x
jpprm=: P{.~F I. 1+]

Fs=. 2}.!i.1+{:P
jpfct=: Fs |.@:{.~ Fs I. 1+]

isjp=: {{
  if. 2>y do. y return.
  elseif. 0 < #(q:y)-.jpprm y do. 0 return.
  else.
    for_f. (#~ ] = <.) (%jpfct) y do.
      if. isjp f do. 1 return. end.
    end.
  end.
  0
}}"0

showjp=: {{
  if. 2>y do. i.0 return. end.
  F=. f{~1 i.~b #inv isjp Y#~b=. (]=<.) Y=. y%f=. jpfct y
  F,showjp y%F
}}

NB. generate a Jordan-Pólya of the given length
jpseq=: {{
  r=. 1 2x   NB. sequence, so far
  f=. 2 6x   NB. factorial factors
  i=. 1 0    NB. index of next item of f for each element of r
  g=. 6 4x   NB. product of r with selected item of f
  while. y>#r do.
    r=. r, nxt=. <./g  NB. next item in r
    j=. I.b=. g=nxt    NB. items of g which just be recalculated
    if. nxt={:f do.    NB. need new factorial factor/
      f=. f,!2+#f
    end.
    i=. 0,~i+b         NB. update indices into f
    g=. (2*nxt),~((j{r)*((<:#f)<.j{i){f) j} g
  end.
  y{.r
}}

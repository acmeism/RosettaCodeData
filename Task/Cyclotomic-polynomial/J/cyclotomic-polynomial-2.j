{{ if.0>nc<'cache' do.cache=:y end.}} (,1);_1 1

cyclotomic=: {{
   if.y<#cache do.
     if.#c=. y{::cache do.
       c return.
     end.
   end.
   c=. unpad cyclotomic000 y
   if. y>:#cache do. cache=:(100+y){.cache end.
   cache=: (<c) y} cache
   c
}}

cyclotomic000=:  {{ assert.0<y
   'q p'=. __ q: y
   if. 1=#q do.
     ,(y%*/q) {."0 q#1
   elseif.2={.q do.
     ,(y%*/q) {."0 (* 1 _1 $~ #) cyclotomic */}.q
   elseif. 1 e. 1 < p do.
     ,(y%*/q) {."0 cyclotomic */q
   else.
     (_1,(-y){.1) pDiv ;+//.@(*/)each/ cyclotomic each}:*/@>,{1,each q
   end.
}}


NB. discard high order zero coefficients in representation of polynomial
unpad=: {.~ 1+0 i:~0=]

NB. polynomial division, optimized for somewhat sparse polynomials
pDiv=: {{
  q=. $j=. 2 + x -&# y
  'x y'=. x,:y
  while. j=. j-1 do.
    if. 0={.x do. j=. j-<:i=. 0 i.~ 0=x
      q=. q,i#0
      x=. i |.!.0 x
    else.
      q=. q, r=. x %&{. y
      x=. 1 |.!.0 x - y*r
    end.
  end.q
}}

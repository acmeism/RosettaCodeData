mergesort=: {{
  if. 2>#y do. y return.end.
  middle=. <.-:#y
  X=. mergesort middle{.y
  Y=. mergesort middle}.y
  X merge Y
}}

merge=: {{ r=. y#~ i=. j=. 0
  while. (i<#x)*(j<#y) do. a=. i{x [b=. j{y
    if. a<b do. r=. r,a [i=. i+1
       else.    r=. r,b [j=. j+1 end.
  end.
  if. i<#x do. r=. r, i}.x end.
  if. j<#y do. r=. r, j}.y end.
}}

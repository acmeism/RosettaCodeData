removeLines=: 4 :0
  'count start'=. x
  file=. boxxopen y
  lines=. <;.2 fread file
  (;lines {~ <<< (start-1)+i.count) fwrite file
)

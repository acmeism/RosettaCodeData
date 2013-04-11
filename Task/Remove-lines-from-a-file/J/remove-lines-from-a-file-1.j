removeLines=:4 :0
  'count start'=. x
  file=. boxxopen y
  lines=. <;.2]1!:1 file
  (;lines {~ <<< (start-1)+i.count) 1!:2 file
)

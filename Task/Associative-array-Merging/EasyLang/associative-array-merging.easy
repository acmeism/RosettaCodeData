base$[][] = [ [ "name" "Rocket Skates" ] [ "price" 12.75 ] [ "color" "yellow" ] ]
update$[][] = [ [ "price" 15.25 ] [ "color" "red" ] [ "year" 1974 ] ]
proc update . a$[][] b$[][] .
   for b to len b$[][]
      for a to len a$[][]
         if a$[a][1] = b$[b][1]
            a$[a][2] = b$[b][2]
            break 1
         .
      .
      if a > len a$[][]
         a$[][] &= b$[b][]
      .
   .
.
update base$[][] update$[][]
print base$[][]

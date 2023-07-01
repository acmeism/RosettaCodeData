: eulerSum
| i j k l ip jp kp |
   250 loop: i [
      i 5 pow ->ip
      i 1 + 250 for: j [
         j 5 pow ip + ->jp
         j 1 + 250 for: k [
            k 5 pow jp + ->kp
            k 1 + 250 for: l [
               kp l 5 pow + 0.2 powf dup asInteger == ifTrue: [ [ i, j, k, l ] println ]
              ]
            ]
         ]
      ] ;

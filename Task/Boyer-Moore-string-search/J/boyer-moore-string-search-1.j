bmsearch0=: {{
   startPos=. 0
   rightMap=. (i.#x) (3 u: x)} 256#_1
   while. (#y) >: (#x)+startPos do.
     skip=. 0
     idx=. #x
     while. 0 <: idx=. idx-1 do.
       if. (idx{x) ~: (startPos+idx) { y do.
         skip=. 1 >. idx - rightMap {~ 3 u: y {~ startPos + idx
         break.
       end.
     end.
     if. skip do.
       startPos=. startPos+skip
     else.
       startPos return.
     end.
   end.
   ''
}}

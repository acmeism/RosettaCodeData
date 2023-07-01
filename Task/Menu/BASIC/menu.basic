 function sel$(choices$(), prompt$)
   if ubound(choices$) - lbound(choices$) = 0 then sel$ = ""
   ret$ = ""
   do
      for i = lbound(choices$) to ubound(choices$)
         print i; ": "; choices$(i)
      next i
      input ;prompt$, index
      if index <= ubound(choices$) and index >= lbound(choices$) then ret$ = choices$(index)
   while ret$ = ""
   sel$ = ret$
end function

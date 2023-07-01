list$ = "abracadabra seesaw pop grrrrrr up a"

while word$(list$,ii + 1," ") <> ""
 ii    = ii + 1
 w$    = word$(list$,ii," ")
 bs$   = bestShuffle$(w$)
 count = 0
 for i = 1 to len(w$)
  if mid$(w$,i,1) = mid$(bs$,i,1) then count = count + 1
 next i
 print  w$;" ";bs$;" ";count
wend

function bestShuffle$(s1$)
   s2$   = s1$
   for i = 1 to len(s2$)
        for j =  1 to len(s2$)
            if (i <> j) and (mid$(s2$,i,1) <> mid$(s1$,j,1)) and (mid$(s2$,j,1) <> mid$(s1$,i,1)) then
            if j < i then i1 = j:j1 = i else i1 = i:j1 = j
            s2$ = left$(s2$,i1-1) + mid$(s2$,j1,1) + mid$(s2$,i1+1,(j1-i1)-1) + mid$(s2$,i1,1) + mid$(s2$,j1+1)
            end if
        next j
   next i
bestShuffle$ = s2$
end function

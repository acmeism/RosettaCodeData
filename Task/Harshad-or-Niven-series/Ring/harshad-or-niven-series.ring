i = 1
count = 0
while true
      sum = 0
      if niven(i) = 1
         if count < 20 see "" + i + " is a Niven number" + nl count +=1 ok
         if i > 1000 see "" + i + " is a Niven number" exit ok ok
      i + =1
end

func niven nr
     nrString = string(nr)
     for j = 1 to len(nrString)
         sum = sum + number(nrString[j])
     next
     niv = ((nr % sum) = 0)
     return niv

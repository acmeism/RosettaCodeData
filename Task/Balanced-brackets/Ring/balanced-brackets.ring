nr = 0
while nr < 10
      nr += 1
      test=generate(random(9)+1)
      see "bracket string " + test + " is " + valid(test) + nl
end

func generate n
l = 0 r = 0 output = ""
while l<n and r<n
      switch random(2)
      on 1 l+=1 output+="["
      on 2 r+=1 output+="]"
      off
end
if l=n output+=copy("]",n-r) else output+=copy("]",n-l) ok
return output

func valid q
count = 0
if len(q)=0 return "ok." ok
for x=1 to len(q)
    if substr(q,x,1)="[" count+=1 else count-=1 ok
    if count<0 return "not ok." ok
next
return "ok."

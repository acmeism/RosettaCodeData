# 100 doors problem
dim d(100)

# simple solution
print "simple solution"
gosub initialize
for t = 1 to 100
   for j = t to 100 step t
      d[j-1] = not d[j-1]
   next j
next t
gosub showopen

# more optimized solution
print "more optimized solution"
gosub initialize
for t = 1 to 10
      d[t^2-1] = true
next t
gosub showopen
end

initialize:
for t = 1 to d[?]
   d[t-1] = false	 # closed
next t
return

showopen:
for t = 1 to d[?]
   print d[t-1]+ " ";
   if t%10 = 0 then print
next t
return

function sqrt2(a,n)
if a
return n>0?2.0:1.0
else
return 1.0
end
end

function napier(a,n)
if a
return n>0?Float64(n):2.0
else
return n>1?n-1.0:1.0
end
end

function _pi(a,n)
if a
return n>0?6.0:3.0
else
return (2.0*n-1.0)^2.0 # exponentiation operator
end
end

function calc(f,expansions)
a=true;b=false
r=0.0
for i=expansions:-1:1
r=f(b,i)/(f(a,i)+r)
end
return f(a,0)+r
end

print("""
sqrt 2 = $(calc(sqrt2, 1000))
e = $(calc(napier, 1000))
 pi = $(calc(_pi, 1000))
""")

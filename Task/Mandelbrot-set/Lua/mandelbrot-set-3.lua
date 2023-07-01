for y=-12,12 do l=""for x=-2,1,3/80 do a,b,n=0,0,-15 while n<9 and a*a+b*b<1e12
do a,b,n=a*a-b*b+x,2*a*b+y/8,n+1 end l=l..(".,:;=$%# "):sub(n,n)end print(l)end

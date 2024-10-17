function pascal(n)
   (n<=0) && error("Pascal trinalge can not have zero or negative rows")
   r=Vector{Int}(undef,n)
   pr=Vector{Int}(undef,n)
   pr[1]=r[1]=1
   println(@view pr[1])
   for i=2:n
      r[1]=r[i]=1
      for j=2:i-1
         r[j]=pr[j-1]+pr[j]
      end
      println(join(view(r,1:i), " "))
      r,pr=pr,r
   end
end

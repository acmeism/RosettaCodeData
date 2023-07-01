local Binomial = setmetatable({},{
 __call = function(self,n,k)
   local hash = (n<<32) | (k & 0xffffffff)
   local ans = self[hash]
   if not ans then
    if n<0 or k>n then
      return 0 -- not save
    elseif n<=1 or k==0 or k==n then
      ans = 1
    else
      if 2*k > n then
        ans = self(n, n - k)
      else
        local lhs = self(n-1,k)
        local rhs = self(n-1,k-1)
        local sum = lhs + rhs
        if sum<0 or not math.tointeger(sum)then
          -- switch to double
          ans = lhs/1.0 + rhs/1.0 -- approximate
        else
          ans = sum
        end
      end
    end
    rawset(self,hash,ans)
   end
   return ans
 end
})
print( Binomial(100,50)) -- 1.0089134454556e+029

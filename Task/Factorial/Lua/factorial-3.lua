fact = setmetatable({[0] = 1}, {
  __call = function(t,n)
    if n < 0 then return 0 end
    if not t[n] then t[n] = n * t(n-1) end
    return t[n]
  end
})

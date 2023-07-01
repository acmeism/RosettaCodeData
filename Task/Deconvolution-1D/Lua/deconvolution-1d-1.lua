function deconvolve(f, g)
   local h = setmetatable({}, {__index = function(self, n)
      if n == 1 then self[1] = g[1] / f[1]
      else
         self[n] = g[n]
         for i = 1, n - 1 do
            self[n] = self[n] - self[i] * (f[n - i + 1] or 0)
         end
         self[n] = self[n] / f[1]
      end
      return self[n]
   end})
   local _ = h[#g - #f + 1]
   return setmetatable(h, nil)
end

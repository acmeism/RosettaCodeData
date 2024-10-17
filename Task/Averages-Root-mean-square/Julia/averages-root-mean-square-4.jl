function rms(A)
   s = 0.0
   for a in A
      s += a*a
   end
   return sqrt(s / length(A))
end

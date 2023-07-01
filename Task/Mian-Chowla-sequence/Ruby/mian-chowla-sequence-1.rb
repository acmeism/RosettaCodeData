require 'set'
n, ts, mc, sums = 100, [], [1], Set.new
sums << 2
st = Time.now
for i in (1 .. (n-1))
   for j in mc[i-1]+1 .. Float::INFINITY
      mc[i] = j
      for k in (0 .. i)
         if (sums.include?(sum = mc[k]+j))
            ts.clear
            break
         end
         ts << sum
      end
      if (ts.length > 0)
         sums = sums | ts
         break
      end
   end
end
et = (Time.now - st) * 1000
s = " of the Mian-Chowla sequence are:\n"
puts "The first 30 terms#{s}#{mc.slice(0..29).join(' ')}\n\n"
puts "Terms 91 to 100#{s}#{mc.slice(90..99).join(' ')}\n\n"
puts "Computation time was #{et.round(1)}ms."

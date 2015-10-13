# Count how many number chains for Natural Numbers < 10**d end with a value of 1.
def iterated_square_digit(d)
  f = Array.new(d+1){|n| (1..n).inject(1, :*)}      #Some small factorials
  g = -> (n) { res = 0
               while n>0
                 n, mod = n.divmod(10)
                 res += mod**2
               end
               res==89 ? 0 : res
             }

  #An array: table[n]==0 means that n translates to 89 and 1 means that n translates to 1
  table = Array.new(d*81+1){|n| n.zero? ? 1 : (i=g.call(n))==89 ? 0 : i}
  table.collect!{|n| n = table[n] while n>1; n}
  z = 0                                             #Running count of numbers translating to 1
  [*0..9].repeated_combination(d) do |rc|           #Iterate over unique digit combinations
    next if table[rc.inject(0){|g,n| g+n*n}].zero?  #Count only ones
    nn = [0] * 10                                   #Determine how many numbers this digit combination corresponds to
    rc.each{|n| nn[n] += 1}
    z += nn.inject(f[d]){|gn,n| gn / f[n]}          #Add to the count of numbers terminating in 1
  end
  puts "\nd=(#{d}) in the range 1 to #{10**d-1}",
       "#{z} numbers produce 1 and #{10**d-1-z} numbers produce 89"
end

[8, 11, 14, 17].each do |d|
  t0 = Time.now
  iterated_square_digit(d)
  puts "  #{Time.now - t0} sec"
end

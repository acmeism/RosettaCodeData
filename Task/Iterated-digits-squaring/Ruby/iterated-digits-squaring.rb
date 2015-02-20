# Count how many number chains for Natural Numbers <= 100,000,000 end with a value 89.
#
#  Nigel_Galloway
#  August 26th., 2014.
require 'benchmark'
D = 8 #Calculate from 1 to 10**D (8 for task)
F = Array.new(D+1){|n| (1..n).inject(1,:*)}    #Some small factorials
g = -> n, gn=[n,0], res=0 { while gn[0]>0
                              gn = gn[0].divmod(10)
                              res += gn[1]**2
                            end
                            res==89 ? 0 : res
                          }
#An array: N[n]==0 means that n translates to 89 and 1 means that n translates to 1
G = Array.new(D*81+1){|n| n==0 ? 1 : (i=g.call(n))==89 ? 0 : i}
N = G.collect{|n| n = G[n] while n>1; n }

z = 0 #Running count of numbers translating to 1
t = Benchmark.measure do
  [*0..9].repeated_combination(D) do |rc|      #Iterate over unique digit combinations
    next if N[rc.inject(0){|g,n| g+n*n}] == 0  #Count only ones
    nn = [0,0,0,0,0,0,0,0,0,0]                 #Determine how many numbers this digit combination corresponds to
    rc.each{|n| nn[n] += 1}
    z += nn.inject(F[D]){|gn,n| gn/F[n]}       #Add to the count of numbers terminating in 1
  end
end
puts "#{z} numbers produce 1 and #{10**D-z} numbers produce 89"
puts "\nTiming\n#{t}"

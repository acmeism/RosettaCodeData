# Count how many number chains for Natural Numbers < 10**K end with a value of 1.
#
#  Nigel_Galloway
#  August 26th., 2014.
K = 17
F = Array.new(K+1){|n| n==0?1:(1..n).inject(:*)}   #Some small factorials
g = -> n, gn=[n,0], res=0 { while gn[0]>0
                              gn = gn[0].divmod(10)
                              res += gn[1]**2
                            end
                            return res==89?0:res
                           }
#An array: N[n]==1 means that n translates to 1, 0 means that it does not.
N = (G=Array.new(K*81+1){|n| n==0? 0:(i=g.call(n))==89 ? 0:i}).collect{|n| while n>1 do n = G[n] end; n }
z = 0   #Running count of numbers translating to 1
(0..9).collect{|n| n**2}.repeated_combination(K).each{|n|   #Iterate over unique digit combinations
    next if N[n.inject(:+)] == 0                            #Count only ones
    nn = Hash.new{0}                                        #Determine how many numbers this digit combination corresponds to
    n.each{|n| nn[n] += 1}                                  #and
    z += nn.values.inject(F[K]){|gn,n| gn/F[n]}             #Add to the count of numbers terminating in 1
}
puts "\nk=(#{K}) in the range 1 to #{10**K-1}\n#{z} numbers produce 1 and #{10**K-1-z} numbers produce 89"

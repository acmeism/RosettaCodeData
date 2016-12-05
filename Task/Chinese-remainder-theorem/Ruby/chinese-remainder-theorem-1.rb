def chinese_remainder(mods, remainders)
  max = mods.inject( :* )
  series = remainders.zip( mods ).map{|r,m| r.step( max, m ).to_a }
  series.inject( :& ).first #returns nil when empty
end

p chinese_remainder([3,5,7], [2,3,2])     #=> 23
p chinese_remainder([10,4,9], [11,22,19]) #=> nil

mian_chowla = Enumerator.new do |yielder|
  mc, sums  = [1], {}
  1.step do |n|
    mc << n
    if  mc.none?{|k| sums[k+n] } then
      mc.each{|k| sums[k+n] = true }
      yielder << n
    else
      mc.pop # n didn't work, get rid of it.
    end
  end
end

res = mian_chowla.take(100).to_a

s = " of the Mian-Chowla sequence are:\n"
puts "The first 30 terms#{s}#{res[0,30].join(' ')}\n
Terms 91 to 100#{s}#{res[90,10].join(' ')}"

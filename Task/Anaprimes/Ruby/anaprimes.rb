require 'prime'

upto = 100_000_000
h = Hash.new {|hash, key| hash[key] = []}
Prime.each(upto) {|pr| h[pr.digits.sort] << pr }

(3..(upto.digits.size-1)).each do |num_digits|
 group = h.select {|k,v| k.size == num_digits}
 sizes = group.values.group_by(&:size)
 max = sizes.keys.max
 maxes = sizes[max]
 puts "Anaprime groups of #{num_digits} digits: #{maxes.size} ha#{maxes.size == 1 ? "s" : "ve"} #{max} primes."
 maxes.each{|group| puts "  First: #{group.first} Last: #{group.last}"}
end

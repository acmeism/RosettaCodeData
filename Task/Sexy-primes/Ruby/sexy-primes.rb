require 'prime'

prime_array, sppair2, sppair3, sppair4, sppair5 = Array.new(5) {Array.new()} # arrays for prime numbers and index number to array for each pair.
unsexy, i, start = [2], 0, Time.now
Prime.each(1_000_100) {|prime| prime_array.push prime}

while prime_array[i] < 1_000_035
  i+=1
  unsexy.push(i) if prime_array[(i+1)..(i+2)].include?(prime_array[i]+6) == false && prime_array[(i-2)..(i-1)].include?(prime_array[i]-6) == false && prime_array[i]+6 < 1_000_035
  prime_array[(i+1)..(i+4)].include?(prime_array[i]+6) && prime_array[i]+6 < 1_000_035 ? sppair2.push(i) : next
  prime_array[(i+2)..(i+5)].include?(prime_array[i]+12) && prime_array[i]+12 < 1_000_035 ? sppair3.push(i) : next
  prime_array[(i+3)..(i+6)].include?(prime_array[i]+18) && prime_array[i]+18 < 1_000_035 ? sppair4.push(i) : next
  prime_array[(i+4)..(i+7)].include?(prime_array[i]+24) && prime_array[i]+24 < 1_000_035 ? sppair5.push(i) : next
end

puts "\nSexy prime pairs: #{sppair2.size} found:"
sppair2.last(5).each {|prime| print [prime_array[prime], prime_array[prime]+6].join(" - "), "\n"}
puts "\nSexy prime triplets: #{sppair3.size} found:"
sppair3.last(5).each {|prime| print [prime_array[prime], prime_array[prime]+6, prime_array[prime]+12].join(" - "), "\n"}
puts "\nSexy prime quadruplets: #{sppair4.size} found:"
sppair4.last(5).each {|prime| print [prime_array[prime], prime_array[prime]+6, prime_array[prime]+12, prime_array[prime]+18].join(" - "), "\n"}
puts "\nSexy prime quintuplets: #{sppair5.size} found:"
sppair5.last(5).each {|prime| print [prime_array[prime], prime_array[prime]+6, prime_array[prime]+12, prime_array[prime]+18, prime_array[prime]+24].join(" - "), "\n"}

puts "\nUnSexy prime: #{unsexy.size} found. Last 10 are:"
unsexy.last(10).each {|item| print prime_array[item], " "}
print "\n\n", Time.now - start, " seconds"

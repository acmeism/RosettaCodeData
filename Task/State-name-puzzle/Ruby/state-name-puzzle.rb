require 'set'

# 26 prime numbers
Primes = [ 2,  3,  5,  7, 11, 13, 17, 19, 23, 29, 31, 37, 41,
          43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101]
States = [
    "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
    "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho",
    "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine",
    "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi",
    "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey",
    "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio",
    "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
    "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia",
    "Washington", "West Virginia", "Wisconsin", "Wyoming"
]

def print_answer(states)
  # find goedel numbers for all pairs of states
  goedel = lambda {|str| str.chars.map {|c| Primes[c.ord - 65]}.reduce(:*)}
  pairs = Hash.new {|h,k| h[k] = Array.new}
  map = states.uniq.map {|state| [state, goedel[state.upcase.delete("^A-Z")]]}
  map.combination(2) {|(s1,g1), (s2,g2)| pairs[g1 * g2] << [s1, s2]}

  # find pairs without duplicates
  result = []
  pairs.values.select {|val| val.length > 1}.each do |list_of_pairs|
    list_of_pairs.combination(2) do |pair1, pair2|
      if Set[*pair1, *pair2].length == 4
        result << [pair1, pair2]
      end
    end
  end

  # output the results
  result.each_with_index do |(pair1, pair2), i|
    puts "%d\t%s\t%s" % [i+1, pair1.join(', '), pair2.join(', ')]
  end
end

puts "real states only"
print_answer(States)
puts ""
puts "with fictional states"
print_answer(States + ["New Kory", "Wen Kory", "York New", "Kory New", "New Kory"])

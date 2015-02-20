teams = [:a, :b, :c, :d]
matches = teams.combination(2).to_a
outcomes = [:win, :draw, :loss]
gains = {win:[3,0], draw:[1,1], loss:[0,3]}
places_histogram = Array.new(4) {Array.new(10,0)}

# The Array#repeated_permutation method generates the 3^6 different
# possible outcomes
outcomes.repeated_permutation(6).each do |outcome|
  results = Hash.new(0)

  # combine this outcomes with the matches, and generate the points table
  outcome.zip(matches).each do |decision, (team1, team2)|
    results[team1] += gains[decision][0]
    results[team2] += gains[decision][1]
  end

  # accumulate the results
  results.values.sort.reverse.each_with_index do |points, place|
    places_histogram[place][points] += 1
  end
end

fmt = "%s :" + "%4s"*10
puts fmt % [" ", *0..9]
puts fmt % ["-", *["---"]*10]
places_histogram.each.with_index(1) {|hist,place| puts fmt % [place, *hist]}

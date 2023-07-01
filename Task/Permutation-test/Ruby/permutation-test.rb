def statistic(ab, a)
  sumab, suma = ab.inject(:+).to_f, a.inject(:+).to_f
  suma / a.size - (sumab - suma) / (ab.size - a.size)
end

def permutationTest(a, b)
  ab = a + b
  tobs = statistic(ab, a)
  under = count = 0
  ab.combination(a.size) do |perm|
    under += 1 if statistic(ab, perm) <= tobs
    count += 1
  end
  under * 100.0 / count
end

treatmentGroup = [85, 88, 75, 66, 25, 29, 83, 39, 97]
controlGroup   = [68, 41, 10, 49, 16, 65, 32, 92, 28, 98]
under = permutationTest(treatmentGroup, controlGroup)
puts "under=%.2f%%, over=%.2f%%" % [under, 100 - under]

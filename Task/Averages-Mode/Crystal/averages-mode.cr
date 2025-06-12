def mode (seq)
  seq.tally.group_by {|n, count| count }.max[1].map {|n, count| n }
end

p mode([1, 3, 6, 6, 6, 6, 7, 7, 12, 12, 17])
p mode([1, 1, 2, 4, 4])

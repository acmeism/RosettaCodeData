def partition(mask)
  return [[]] if mask.empty?
  [*1..mask.inject(:+)].permutation.map {|perm|
    mask.map {|num_elts| perm.shift(num_elts).sort }
  }.uniq
end

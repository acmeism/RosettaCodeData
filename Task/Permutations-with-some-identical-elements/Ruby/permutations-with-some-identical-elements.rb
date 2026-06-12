require 'set' # for older Ruby versions

def permutations_with_identical_elements(reps, elements=nil)
  elements ||= (1..reps.size)
  all = elements.zip(reps).flat_map{|el, r| [el]*r}
  all.permutation.inject(Set.new){|s, perm| s << perm.join}
end

permutations_with_identical_elements([2,3,1]).each_slice(10) {|slice| puts slice.join(" ")}

p permutations_with_identical_elements([2,1], ["A", "B"])

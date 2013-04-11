class Array
  # Yields distinct permutations of _self_ to the block.
  # This method requires that all array elements be Comparable.
  def distinct_permutation  # :yields: _ary_
    # If no block, return an enumerator. Works with Ruby 1.8.7.
    block_given? or return enum_for(:distinct_permutation)

    copy = self.sort
    yield copy.dup
    return if size < 2

    while true
      # from: "The Art of Computer Programming" by Donald Knuth
      j = size - 2;
      j -= 1 while j > 0 && copy[j] >= copy[j+1]
      if copy[j] < copy[j+1]
        l = size - 1
        l -= 1 while copy[j] >= copy[l]
        copy[j] , copy[l] = copy[l] , copy[j]
        copy[j+1..-1] = copy[j+1..-1].reverse
        yield copy.dup
      else
        break
      end
    end
  end
end

permutations = []
[1,1,2].distinct_permutation do |p| permutations << p end
p permutations
# => [[1, 1, 2], [1, 2, 1], [2, 1, 1]]

if RUBY_VERSION >= "1.8.7"
  p [1,1,2].distinct_permutation.to_a
  # => [[1, 1, 2], [1, 2, 1], [2, 1, 1]]
end

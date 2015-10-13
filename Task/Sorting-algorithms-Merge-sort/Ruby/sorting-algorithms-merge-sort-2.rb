class Array
  def mergesort(&comparitor)
    return self if length <= 1
    comparitor ||= proc{|a, b| a <=> b}
    middle = length / 2
    left  = self[0...middle].mergesort(&comparitor)
    right = self[middle..-1].mergesort(&comparitor)
    merge(left, right, comparitor)
  end

  private
  def merge(left, right, comparitor)
    result = []
    until left.empty? || right.empty?
      # change the direction of this comparison to change the direction of the sort
      if comparitor[left.first, right.first] <= 0
        result << left.shift
      else
        result << right.shift
      end
    end
    result + left + right
  end
end

ary = [7,6,5,9,8,4,3,1,2,0]
p ary.mergesort                    # => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
p ary.mergesort {|a, b| b <=> a}   # => [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

ary = [["UK", "London"], ["US", "New York"], ["US", "Birmingham"], ["UK", "Birmingham"]]
p ary.mergesort
# => [["UK", "Birmingham"], ["UK", "London"], ["US", "Birmingham"], ["US", "New York"]]
p ary.mergesort {|a, b| a[1] <=> b[1]}
# => [["US", "Birmingham"], ["UK", "Birmingham"], ["UK", "London"], ["US", "New York"]]

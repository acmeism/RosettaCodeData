class Array
  def mergesort(&comparitor)
    if length <= 1
      self
    else
      unless comparitor
        comparitor = lambda {|a, b| a <=> b}
      end
      middle = length / 2
      left  = self[0,  middle].mergesort(&comparitor)
      right = self[middle..-1].mergesort(&comparitor)
      merge(left, right, comparitor)
    end
  end

  protected
  def merge(left, right, comparitor)
    if left.empty?
      right
    elsif right.empty?
      left
    elsif comparitor.call(left.first, right.first) <= 0
      [left.first] + merge(left[1..-1], right, comparitor)
    else
      [right.first] + merge(left, right[1..-1], comparitor)
    end
  end
end

ary = [7,6,5,9,8,4,3,1,2,0]
ary.mergesort                    # => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
ary.mergesort {|a, b| b <=> a}   # => [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

ary = [["UK", "London"], ["US", "New York"], ["US", "Birmingham"], ["UK", "Birmingham"]]
ary.mergesort {|a, b| a[1] <=> b[1]}
# => [["US", "Birmingham"], ["UK", "Birmingham"], ["UK", "London"], ["US", "New York"]]

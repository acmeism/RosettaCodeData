class Array
  # used Hash
  def uniq1
    each_with_object({}) {|elem, h| h[elem] = true}.keys
  end
  # sort (requires comparable)
  def uniq2
    sorted = sort
    pre = sorted.first
    sorted.each_with_object([pre]){|elem, uniq| uniq << (pre = elem) if elem != pre}
  end
  # go through the list
  def uniq3
    each_with_object([]) {|elem, uniq| uniq << elem unless uniq.include?(elem)}
  end
end

ary = [1,1,2,1,'redundant',[1,2,3],[1,2,3],'redundant']
p ary.uniq1             #=> [1, 2, "redundant", [1, 2, 3]]
p ary.uniq2 rescue nil  #   Error (not comparable)
p ary.uniq3             #=> [1, 2, "redundant", [1, 2, 3]]

ary = [1,2,3,7,6,5,2,3,4,5,6,1,1,1]
p ary.uniq1             #=> [1, 2, 3, 7, 6, 5, 4]
p ary.uniq2             #=> [1, 2, 3, 4, 5, 6, 7]
p ary.uniq3             #=> [1, 2, 3, 7, 6, 5, 4]

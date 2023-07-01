def mode(ary)
  seen = Hash.new(0)
  ary.each {|value| seen[value] += 1}
  max = seen.values.max
  seen.find_all {|key,value| value == max}.map {|key,value| key}
end

def mode_one_pass(ary)
  seen = Hash.new(0)
  max = 0
  max_elems = []
  ary.each do |value|
    seen[value] += 1
    if seen[value] > max
      max = seen[value]
      max_elems = [value]
    elsif seen[value] == max
      max_elems << value
    end
  end
  max_elems
end

p mode([1, 3, 6, 6, 6, 6, 7, 7, 12, 12, 17])  # => [6]
p mode([1, 1, 2, 4, 4]) # => [1, 4]
p mode_one_pass([1, 3, 6, 6, 6, 6, 7, 7, 12, 12, 17])  # => [6]
p mode_one_pass([1, 1, 2, 4, 4]) # => [1, 4]

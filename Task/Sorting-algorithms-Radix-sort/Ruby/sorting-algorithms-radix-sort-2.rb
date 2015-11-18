class Array
  def radix_sort(base=10)
    ary = dup
    m, max = 1, ary.minmax.map(&:abs).max
    while m <= max
      buckets = Array.new(base){[]}
      ary.each {|n| buckets[(n.abs / m) % base] << n}
      ary = buckets.flatten
      m *= base
    end
    ary.partition{|n| n<0}.inject{|minus,plus| minus.reverse + plus}
  end
end

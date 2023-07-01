class Array
  def circle_sort!
    while _circle_sort!(0, size-1) > 0
    end
    self
  end

  private
  def _circle_sort!(lo, hi, swaps=0)
    return swaps if lo == hi
    low, high = lo, hi
    mid = (lo + hi) / 2
    while lo < hi
      if self[lo] > self[hi]
        self[lo], self[hi] = self[hi], self[lo]
        swaps += 1
      end
      lo += 1
      hi -= 1
    end
    if lo == hi && self[lo] > self[hi+1]
      self[lo], self[hi+1] = self[hi+1], self[lo]
      swaps += 1
    end
    swaps + _circle_sort!(low, mid) + _circle_sort!(mid+1, high)
  end
end

ary = [6, 7, 8, 9, 2, 5, 3, 4, 1]
puts "before sort: #{ary}"
puts " after sort: #{ary.circle_sort!}"

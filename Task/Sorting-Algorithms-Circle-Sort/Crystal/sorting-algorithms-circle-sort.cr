class Array
  private def circle_sort_ (lo, hi)
    return 0 if lo == hi
    swaps = 0
    low, high = lo, hi
    mid = (hi - lo) // 2
    while lo < hi
      if self[lo] > self[hi]
        swap lo, hi
        swaps += 1
      end
      lo += 1
      hi -= 1
    end
    if lo == hi && self[lo] > self[hi+1]
      swap lo, hi+1
      swaps += 1
    end
    swaps + circle_sort_(low, low+mid) + circle_sort_(low+mid+1, high)
  end

  def circle_sort!
    while circle_sort_(0, size-1) > 0
    end
    self
  end
end

arr = Array.new(20) { rand 100 }
p arr
p arr.circle_sort!

arr = %w(The quick brown fox jumps over the lazy dog.)
p arr
p arr.circle_sort!

module Indexable::Mutable
  def stooge_sort!
    stooge_sort_impl 0, size-1
    self
  end

  private def stooge_sort_impl (i, j)
    swap(i, j) if self[i] > self[j]
    if j - i + 1 > 2
      t = (j - i + 1) // 3
      stooge_sort_impl i,   j-t
      stooge_sort_impl i+t, j
      stooge_sort_impl i,   j-t
    end
  end
end

arr = Array(Int32).new(15) { (-50..100).sample }
puts "before: #{arr}"
puts "after:  #{arr.stooge_sort!}"

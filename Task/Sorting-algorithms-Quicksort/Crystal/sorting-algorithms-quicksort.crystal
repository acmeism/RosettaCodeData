def quick_sort(a : Array(Int32)) : Array(Int32)
  return a if a.size <= 1
  p = a[0]
  lt, rt = a[1 .. -1].partition { |x| x < p }
  return quick_sort(lt) + [p] + quick_sort(rt)
end

a = [7, 6, 5, 9, 8, 4, 3, 1, 2, 0]
puts quick_sort(a) # => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

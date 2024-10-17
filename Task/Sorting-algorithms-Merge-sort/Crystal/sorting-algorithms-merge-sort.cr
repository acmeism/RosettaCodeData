def merge_sort(a : Array(Int32)) : Array(Int32)
  return a if a.size <= 1
  m = a.size // 2
  lt = merge_sort(a[0 ... m])
  rt = merge_sort(a[m .. -1])
  return merge(lt, rt)
end

def merge(lt : Array(Int32), rt : Array(Int32)) : Array(Int32)
  result = Array(Int32).new
  until lt.empty? || rt.empty?
    result << (lt.first < rt.first ? lt.shift : rt.shift)
  end
  return result + lt + rt
end

a = [7, 6, 5, 9, 8, 4, 3, 1, 2, 0]
puts merge_sort(a) # => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

class Array
  def binary_search_iterative(val)
    low, high = 0, size - 1
    while low <= high
      #mid = (low + high) >> 1
      mid = low + ((high - low) >> 1)
      case val <=> self[mid]
        when 1
          low = mid + 1
        when -1
          high = mid - 1
        else
          return mid
      end
    end
    nil
  end
end

ary = [0,1,4,5,6,7,8,9,12,26,45,67,78,90,98,123,211,234,456,769,865,2345,3215,14345,24324]

[0, 42, 45, 24324, 99999].each do |val|
  i = ary.binary_search_iterative(val)
  if i
    puts "found #{val} at index #{i}: #{ary[i]}"
  else
    puts "#{val} not found in array"
  end
end

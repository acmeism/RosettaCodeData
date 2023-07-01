def jort_sort(array)
  # sort the array
  original_array = array.dup
  array.sort!

  # compare to see if it was originally sorted
  original_array.length.times do |i|
    return false if original_array[i] != array[i]
  end

  true
end

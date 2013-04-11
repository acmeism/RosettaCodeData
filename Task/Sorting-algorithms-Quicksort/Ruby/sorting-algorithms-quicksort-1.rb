class Array
  def quick_sort
    return self if length <= 1
    pivot = self[length / 2]
    find_all { |i| i <  pivot }.quick_sort +
      find_all { |i| i == pivot } +
      find_all { |i| i >  pivot }.quick_sort
  end
end

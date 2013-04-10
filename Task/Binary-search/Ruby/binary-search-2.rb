class Array
  def binary_search_iterative(val)
    low, high = 0, length - 1
    while low <= high
      mid = (low + high) / 2
      case
        when self[mid] > val then high = mid - 1
        when self[mid] < val then low = mid + 1
        else return mid
      end
    end
    nil
  end
end

ary = [0,1,4,5,6,7,8,9,12,26,45,67,78,90,98,123,211,234,456,769,865,2345,3215,14345,24324]
do_a_binary_search(45, ary, :binary_search_iterative)
do_a_binary_search(42, ary, :binary_search_iterative)

class Array
  def binary_search(val, low=0, high=(length - 1))
    return nil if high < low
    mid = (low + high) / 2
    case
      when self[mid] > val then binary_search(val, low, mid-1)
      when self[mid] < val then binary_search(val, mid+1, high)
      else mid
    end
  end
end

def do_a_binary_search(val, ary, method)
  i = ary.send(method, val)
  if i
    puts "found #{val} at index #{i}: #{ary[i]}"
  else
    puts "#{val} not found in array"
  end
end

ary = [0,1,4,5,6,7,8,9,12,26,45,67,78,90,98,123,211,234,456,769,865,2345,3215,14345,24324]
do_a_binary_search(45, ary, :binary_search)
do_a_binary_search(42, ary, :binary_search)

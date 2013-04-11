class Array
  def insertionsort!
    return if length < 2

    1.upto(length - 1) do |i|
      value = delete_at i
      j = i - 1
      j -= 1 while j >= 0 && value < self[j]
      insert(j + 1, value)
    end
    self
  end
end

ary = [7,6,5,9,8,4,3,1,2,0]
ary.insertionsort!
# => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

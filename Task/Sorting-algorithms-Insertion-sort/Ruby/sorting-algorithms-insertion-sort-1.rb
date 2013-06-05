class Array
  def insertionsort!
    1.upto(length - 1) do |i|
      value = self[i]
      j = i - 1
      while j >= 0 and self[j] > value
        self[j+1] = self[j]
        j -= 1
      end
      self[j+1] = value
    end
    self
  end
end
ary = [7,6,5,9,8,4,3,1,2,0]
p ary.insertionsort!
# => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

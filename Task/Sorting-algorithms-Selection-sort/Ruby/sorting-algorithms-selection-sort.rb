class Array
  def selectionsort!
    0.upto(length - 2) do |i|
      (min_idx = i + 1).upto(length - 1) do |j|
        if self[j] < self[min_idx]
          min_idx = j
        end
      end
      if self[i] > self[min_idx]
        self[i], self[min_idx] = self[min_idx], self[i]
      end
    end
    self
  end
end
ary = [7,6,5,9,8,4,3,1,2,0]
ary.selectionsort!
# => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

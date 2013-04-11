class Array
  def cocktailsort!
    begin
      swapped = false
      0.upto(length - 2) do |i|
        if self[i] > self[i + 1]
          self[i], self[i + 1] = self[i + 1], self[i]
          swapped = true
        end
      end
      break if not swapped

      swapped = false
      (length - 2).downto(0) do |i|
        if self[i] > self[i + 1]
          self[i], self[i + 1] = self[i + 1], self[i]
          swapped = true
        end
      end
    end while swapped
    self
  end
end
ary = [7,6,5,9,8,4,3,1,2,0]
ary.cocktailsort!
# => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

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
      break unless swapped

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

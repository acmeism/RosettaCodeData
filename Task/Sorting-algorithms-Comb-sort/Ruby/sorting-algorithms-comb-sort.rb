class Array
  def combsort!
    gap = size
    swaps = true
    until gap <= 1 and swaps
      gap = (gap / 1.25).to_int
      swaps = false
      0.upto(size - gap - 1) do |i|
        if self[i] > self[i+gap]
          self[i], self[i+gap] = self[i+gap], self[i]
          swaps = true
        end
      end
    end
    self
  end
end

p [23, 76, 99, 58, 97, 57, 35, 89, 51, 38, 95, 92, 24, 46, 31, 24, 14, 12, 57, 78].combsort!

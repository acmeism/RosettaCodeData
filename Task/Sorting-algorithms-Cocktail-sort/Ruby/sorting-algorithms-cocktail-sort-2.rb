class Array
  def cocktailsort!
    start, finish, way = 0, size-1, 1
    loop do
      swapped = false
      start.step(finish-way, way) do |i|
        if (self[i] <=> self[i + way]) == way
          self[i], self[i + way] = self[i + way], self[i]
          swapped = i
        end
      end
      break unless swapped
      start, finish, way = swapped, start, -way
    end
    self
  end
end

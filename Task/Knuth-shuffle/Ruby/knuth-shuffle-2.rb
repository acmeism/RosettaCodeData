class Array
  def knuth_shuffle!
    (length - 1).downto(1) do |i|
      j = rand(i + 1)
      self[i], self[j] = self[j], self[i]
    end
    self
  end
end

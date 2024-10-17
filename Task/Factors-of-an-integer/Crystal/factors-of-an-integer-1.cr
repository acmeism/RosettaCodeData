struct Int
  def factors() (1..self).select { |n| (self % n).zero? } end
end

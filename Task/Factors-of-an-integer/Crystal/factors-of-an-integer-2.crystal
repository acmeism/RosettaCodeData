struct Int
  def factors
    f = [] of Int32
    (1..Math.sqrt(self)).each{ |i|
      (f << i; f << self // i if self // i != i) if (self % i).zero?
    }
    f.sort
  end
end

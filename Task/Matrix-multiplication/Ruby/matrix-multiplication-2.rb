def matrix_mult(a, b)
  a.map do |ar|
    b.transpose.map { |bc| ar.zip(bc).map{ |x| x.inject(&:*) }.sum }
  end
end

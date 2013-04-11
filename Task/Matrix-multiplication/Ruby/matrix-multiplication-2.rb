def matrix_mult(a, b)
  a.map do |ar|
    b.transpose.map do |bc|
      ar.zip(bc).map {|x,y| x*y}.inject {|z,w| z+w}
    end
  end
end

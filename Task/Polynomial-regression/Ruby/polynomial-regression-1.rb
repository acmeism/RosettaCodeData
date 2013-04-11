require 'matrix'

def regress x, y, degree
  x_data = x.map { |xi| (0..degree).map { |pow| (xi**pow).to_f } }

  mx = Matrix[*x_data]
  my = Matrix.column_vector(y)

  ((mx.t * mx).inv * mx.t * my).transpose.to_a[0]
end

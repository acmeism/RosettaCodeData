require 'matrix'

def regression_coefficients y, x
  y = Matrix.column_vector y.map { |i| i.to_f }
  x = Matrix.columns x.map { |xi| xi.map { |i| i.to_f }}

  (x.t * x).inverse * x.t * y
end

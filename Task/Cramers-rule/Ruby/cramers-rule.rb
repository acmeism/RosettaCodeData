require 'matrix'

def cramers_rule(a, terms)
  raise ArgumentError, " Matrix not square"  unless a.square?
  cols = a.to_a.transpose
  cols.each_index.map do |i|
    c = cols.dup
    c[i] = terms
    Matrix.columns(c).det / a.det
  end
end

matrix = Matrix[
    [2, -1,  5,  1],
    [3,  2,  2, -6],
    [1,  3,  3, -1],
    [5, -2, -3,  3],
]

vector = [-3, -32, -47, 49]
puts cramers_rule(matrix, vector)

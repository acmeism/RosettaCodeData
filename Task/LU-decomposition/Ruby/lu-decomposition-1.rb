require 'matrix'

class Matrix
  def lu_decomposition
    p = get_pivot
    tmp = p * self
    u = Matrix.zero(row_size).to_a
    l = Matrix.identity(row_size).to_a
    (0 ... row_size).each do |i|
      (0 ... row_size).each do |j|
        if j >= i
          # upper
          u[i][j] = tmp[i,j] - (0 ... i).inject(0.0) {|sum, k| sum + u[k][j] * l[i][k]}
        else
          # lower
          l[i][j] = (tmp[i,j] - (0 ... j).inject(0.0) {|sum, k| sum + u[k][j] * l[i][k]}) / u[j][j]
        end
      end
    end
    [ Matrix[*l], Matrix[*u], p ]
  end

  def get_pivot
    raise ArgumentError, "must be square" unless square?
    id = Matrix.identity(row_size).to_a
    (0 ... row_size).each do |i|
      max = self[i,i]
      row = i
      (i ... row_size).each do |j|
        if self[j,i] > max
          max = self[j,i]
          row = j
        end
      end
      id[i], id[row] = id[row], id[i]
    end
    Matrix[*id]
  end

  def pretty_print(format, head=nil)
    puts head if head
    puts each_slice(column_size).map{|row| format*row_size % row}
  end
end

puts "Example 1:"
a = Matrix[[1,  3,  5],
           [2,  4,  7],
           [1,  1,  0]]
a.pretty_print(" %2d", "A")
l, u, p = a.lu_decomposition
l.pretty_print(" %8.5f", "L")
u.pretty_print(" %8.5f", "U")
p.pretty_print(" %d",    "P")

puts "\nExample 2:"
a = Matrix[[11, 9,24,2],
           [ 1, 5, 2,6],
           [ 3,17,18,1],
           [ 2, 5, 7,1]]
a.pretty_print(" %2d", "A")
l, u, p = a.lu_decomposition
l.pretty_print(" %8.5f", "L")
u.pretty_print(" %8.5f", "U")
p.pretty_print(" %d",    "P")

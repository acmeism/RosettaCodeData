require 'matrix'

class Matrix
  def self.two_diagonals(n)
    Matrix.build(n, n) do |row, col|
      row == col || row == n-col-1 ? 1 : 0
    end
  end
end

Matrix.two_diagonals(5).row_vectors.each{|row| puts row.to_a.join(" ") }

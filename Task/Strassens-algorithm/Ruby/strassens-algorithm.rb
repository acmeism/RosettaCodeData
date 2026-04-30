class Shape < Struct.new(:rows, :cols)
end

class Matrix
  attr_reader :data

  def initialize(data = [])
    @data = data
  end

  def self.block(blocks)
    m = []
    # blocks is an array of arrays of Matrix objects
    # Process horizontal blocks row by row
    top_blocks = blocks[0]  # [c11, c12]
    bottom_blocks = blocks[1]  # [c21, c22]

    # Combine top blocks horizontally
    top_rows = []
    (0...top_blocks[0].rows).each do |i|
      row = []
      top_blocks.each { |block| row.concat(block.data[i]) }
      top_rows << row
    end

    # Combine bottom blocks horizontally
    bottom_rows = []
    (0...bottom_blocks[0].rows).each do |i|
      row = []
      bottom_blocks.each { |block| row.concat(block.data[i]) }
      bottom_rows << row
    end

    # Combine all rows vertically
    m = top_rows + bottom_rows
    Matrix.new(m)
  end

  def dot(b)
    raise "Matrix dimensions don't match" unless self.cols == b.rows

    result = []
    @data.each do |row|
      new_row = []
      b.cols.times do |c|
        col = b.data.map { |r| r[c] }
        new_row << row.zip(col).map { |x, y| x * y }.sum
      end
      result << new_row
    end
    Matrix.new(result)
  end

  def *(b)
    dot(b)
  end

  def +(b)
    raise "Matrix dimensions don't match" unless self.shape == b.shape

    rows, cols = self.rows, self.cols
    result = []
    rows.times do |i|
      new_row = []
      cols.times do |j|
        new_row << @data[i][j] + b.data[i][j]
      end
      result << new_row
    end
    Matrix.new(result)
  end

  def -(b)
    raise "Matrix dimensions don't match" unless self.shape == b.shape

    rows, cols = self.rows, self.cols
    result = []
    rows.times do |i|
      new_row = []
      cols.times do |j|
        new_row << @data[i][j] - b.data[i][j]
      end
      result << new_row
    end
    Matrix.new(result)
  end

  def strassen(b)
    rows, cols = self.rows, self.cols

    raise "Matrices must be square" unless rows == cols
    raise "Matrices must be the same shape" unless self.shape == b.shape
    raise "Shape must be a power of 2" unless rows > 0 && (rows & (rows - 1)) == 0

    if rows == 1
      return self.dot(b)
    end

    p = rows / 2

    a11 = Matrix.new(@data[0...p].map { |row| row[0...p] })
    a12 = Matrix.new(@data[0...p].map { |row| row[p..-1] })
    a21 = Matrix.new(@data[p..-1].map { |row| row[0...p] })
    a22 = Matrix.new(@data[p..-1].map { |row| row[p..-1] })

    b11 = Matrix.new(b.data[0...p].map { |row| row[0...p] })
    b12 = Matrix.new(b.data[0...p].map { |row| row[p..-1] })
    b21 = Matrix.new(b.data[p..-1].map { |row| row[0...p] })
    b22 = Matrix.new(b.data[p..-1].map { |row| row[p..-1] })

    m1 = (a11 + a22).strassen(b11 + b22)
    m2 = (a21 + a22).strassen(b11)
    m3 = a11.strassen(b12 - b22)
    m4 = a22.strassen(b21 - b11)
    m5 = (a11 + a12).strassen(b22)
    m6 = (a21 - a11).strassen(b11 + b12)
    m7 = (a12 - a22).strassen(b21 + b22)

    c11 = m1 + m4 - m5 + m7
    c12 = m3 + m5
    c21 = m2 + m4
    c22 = m1 - m2 + m3 + m6

    Matrix.block([[c11, c12], [c21, c22]])
  end

  def round(ndigits = nil)
    rounded_data = @data.map do |row|
      row.map do |element|
        if ndigits
          (element * (10 ** ndigits)).round / (10.0 ** ndigits)
        else
          element.round
        end
      end
    end
    Matrix.new(rounded_data)
  end

  def shape
    cols = @data.empty? ? 0 : @data[0].length
    Shape.new(@data.length, cols)
  end

  def rows
    @data.length
  end

  def cols
    @data.empty? ? 0 : @data[0].length
  end

  def to_s
    @data.inspect
  end

  def inspect
    @data.inspect
  end
end

def examples
  a = Matrix.new([
    [1, 2],
    [3, 4]
  ])

  b = Matrix.new([
    [5, 6],
    [7, 8]
  ])

  c = Matrix.new([
    [1, 1, 1, 1],
    [2, 4, 8, 16],
    [3, 9, 27, 81],
    [4, 16, 64, 256]
  ])

  d = Matrix.new([
    [4, -3, 4.0/3, -1.0/4],
    [-13.0/3, 19.0/4, -7.0/3, 11.0/24],
    [3.0/2, -2, 7.0/6, -1.0/4],
    [-1.0/6, 1.0/4, -1.0/6, 1.0/24]
  ])

  e = Matrix.new([
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
    [13, 14, 15, 16]
  ])

  f = Matrix.new([
    [1, 0, 0, 0],
    [0, 1, 0, 0],
    [0, 0, 1, 0],
    [0, 0, 0, 1]
  ])

  puts "Naive matrix multiplication:"
  puts "  a * b = #{a * b}"
  puts "  c * d = #{(c * d).round}"
  puts "  e * f = #{e * f}"

  puts "Strassen's matrix multiplication:"
  puts "  a * b = #{a.strassen(b)}"
  puts "  c * d = #{c.strassen(d).round}"
  puts "  e * f = #{e.strassen(f)}"
end

if __FILE__ == $0
  examples
end

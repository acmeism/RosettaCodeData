class Magic_square
  attr_reader :square
  LUX = { L: [[4, 1], [2, 3]], U: [[1, 4], [2, 3]], X: [[1, 4], [3, 2]] }

  def initialize(n)
    raise ArgumentError, "must be even, but not divisible by 4." unless (n-2) % 4 == 0
    raise ArgumentError, "2x2 magic square not possible." if n == 2
    @n = n
    oms = odd_magic_square(n/2)
    mat = make_lux_matrix(n/2)
    @square = synthesize(oms, mat)
    puts to_s
  end

  def odd_magic_square(n)       # zero beginning, it is 4 multiples.
    n.times.map{|i| n.times.map{|j| (n*((i+j+1+n/2)%n) + ((i+2*j-5)%n)) * 4} }
  end

  def make_lux_matrix(n)
    center = n / 2
    lux = [*[:L]*(center+1), :U, *[:X]*(n-center-2)]
    matrix = lux.map{|x| Array.new(n, x)}
    matrix[center][center] = :U
    matrix[center+1][center] = :L
    matrix
  end

  def synthesize(oms, mat)
    range = 0...@n/2
    range.inject([]) do |matrix,i|
      row = [[], []]
      range.each do |j|
        x = oms[i][j]
        LUX[mat[i][j]].each_with_index{|lux,k| row[k] << lux.map{|y| x+y}}
      end
      matrix << row[0].flatten << row[1].flatten
    end
  end

  def to_s
    format = "%#{(@n*@n).to_s.size}d " * @n + "\n"
    @square.map{|row| format % row}.join
  end
end

sq = Magic_square.new(6).square

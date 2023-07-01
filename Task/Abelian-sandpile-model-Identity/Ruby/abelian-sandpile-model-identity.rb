class Sandpile

  def initialize(ar) = @grid = ar

  def to_a = @grid.dup

  def + (other)
    res = self.to_a.zip(other.to_a).map{|row1, row2| row1.zip(row2).map(&:sum) }
    Sandpile.new(res)
  end

  def stable? = @grid.flatten.none?{|v| v > 3}

  def avalanche
    topple until stable?
    self
  end

  def == (other) = self.avalanche.to_a == other.avalanche.to_a

  def topple
    a = @grid
    a.each_index do |row|
       a[row].each_index do |col|
        next if a[row][col] < 4
        a[row+1][col] += 1 unless row == a.size-1
        a[row-1][col] += 1 if row > 0
        a[row][col+1] += 1 unless col == a.size-1
        a[row][col-1] += 1 if col > 0
        a[row][col]   -= 4
      end
    end
    self
  end

  def to_s = "\n" + @grid.map {|row| row.join(" ") }.join("\n")

end

puts "Sandpile:"
puts demo = Sandpile.new( [[4,3,3], [3,1,2],[0,2,3]] )
puts "\nAfter the avalanche:"
puts demo.avalanche
puts "_" * 30,""

s1 = Sandpile.new([[1, 2, 0], [2, 1, 1], [0, 1, 3]] )
puts "s1: #{s1}"
s2 = Sandpile.new([[2, 1, 3], [1, 0, 1], [0, 1, 0]] )
puts "\ns2: #{s2}"
puts "\ns1 + s2 == s2 + s1: #{s1 + s2 == s2 + s1}"
puts "_" * 30,""

s3    = Sandpile.new([[3, 3, 3], [3, 3, 3], [3, 3, 3]] )
s3_id = Sandpile.new([[2, 1, 2], [1, 0, 1], [2, 1, 2]] )
puts "s3 + s3_id == s3: #{s3 + s3_id == s3}"
puts "s3_id + s3_id == s3_id: #{s3_id + s3_id == s3_id}"

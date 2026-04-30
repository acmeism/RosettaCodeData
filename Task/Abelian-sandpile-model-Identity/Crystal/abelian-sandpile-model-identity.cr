class Sandpile
  getter pile   : Array(Array(Int32))
  getter width  : Int32
  getter height : Int32

  def initialize (values : Array(Array(Int32)))
    @pile = values.map {|row| row.dup }
    @width = @pile[0].size
    @height = @pile.size
    stabilize
  end

  def initialize (@width, @height)
    @pile = Array.new(@height) { Array.new(@width, 0) }
  end

  def stabilize
    pile, h, w = @pile, @width, @height
    loop do
      done = true
      (0...h).each do |r|
        (0...w).each do |c|
          stack = pile[r][c]
          if stack >= 4
            portion = stack // 4
            pile[r][c] %= 4
            (pile[r][c-1] += portion)   if c-1 >= 0
            (pile[r][c+1] += portion)   if c+1 < width
            (pile[r-1][c] += portion)   if r-1 >= 0
            (pile[r+1][c] += portion)   if r+1 < height
            done = false
          end
        end
      end
      break if done
    end
    @pile = pile
    self
  end

  def check_compatible (other)
    raise "incompatible sandpiles" unless other.height == height &&
                                          other.width  == width
  end

  def + (other)
    check_compatible(other)
    new_pile = @pile.zip(other.@pile).map {|(row1, row2)|
      row1.zip(row2).map {|a, b| a + b }
    }
    Sandpile.new(new_pile)
  end
end

def print_row (items)
  heights = items.map {|item| item.is_a?(Sandpile) ? item.height : 1 }
  lines = heights.max
  (0...lines).each do |i|
    items.each do |item|
      if item.is_a?(Sandpile)
        print item.pile[i].join(" ")
      elsif i == lines // 2
        print item
      else
        print " "*item.size
      end
    end
    puts
  end
end


s1 = Sandpile.new([[1,2,0],[2,1,1],[0,1,3]])
s2 = Sandpile.new([[2,1,3],[1,0,1],[0,1,0]])
s3 = Sandpile.new([[3,3,3],[3,3,3],[3,3,3]])
s3_id = Sandpile.new([[2,1,2],[1,0,1],[2,1,2]])

print_row ["s1 + s2 = s2 + s1  =   ", s1, " + ", s2, " = ", s1 + s2,
           "  =  ", s2, " + ", s1, " = ", s2 + s1]

puts
print_row ["s3 + s3_id = s3  =  ",
           s3, " + ", s3_id, " = ", s3 + s3_id]
puts
print_row ["s3_id + s3_id = s3_id  =  ",
           s3_id, " + ", s3_id, " = ", s3_id + s3_id]

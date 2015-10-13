class Queen
  def initialize(num=8)
    @num = num
  end

  def solve(out=true)
    @out   = out
    @row   = *0...@num
    @frame = "+-" + "--" * @num + "+"
    @count = 0
    add = Array.new(2 * @num - 1, true)
    sub = Array.new(2 * @num - 1, true)
    _solve([], add, sub)
    @count
  end

  def _solve(row, add, sub)
    y = row.size
    if y == @num
      print_out(row) if @out
      @count += 1
    else
      (@row-row).each do |x|
        next unless add[x+y] and sub[x-y]
        add[x+y] = sub[x-y] = false
        _solve(row+[x], add, sub)
        add[x+y] = sub[x-y] = true
      end
    end
  end

  def print_out(row)
    puts @frame
    row.each do |i|
      line = @num.times.map {|j| j==i ? "Q " : ". "}.join
      puts "| #{line}|"
    end
    puts @frame
  end
end

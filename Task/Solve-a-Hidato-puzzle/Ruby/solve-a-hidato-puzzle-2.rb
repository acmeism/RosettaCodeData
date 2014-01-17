require 'benchmark'

def print_out(rows, cols, msg=nil)
  puts msg if msg
  (1..rows).each do |r|
    puts (1..cols).map{|c| "%3s" % $board[r][c].value}.join
  end
  puts
end

def test(rows, cols, x, y)
  print_out(rows, cols, 'Problem:')
  puts Benchmark.measure {$board[x][y].try}
  print_out(rows, cols, 'Solution:')
end

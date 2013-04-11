Rows = 3
Cols = 3
E = 7
$zbl = Array.new(E+1,true)
Board = [[Cell.new(),Cell.new()       ,Cell.new()       ,Cell.new()       ,Cell.new()],
         [Cell.new(),Cell.new()       ,Cell.new(1,2,4)  ,Cell.new()       ,Cell.new()],
         [Cell.new(),Cell.new(2,1,0)  ,Cell.new(2,2,7)  ,Cell.new(2,3,0)  ,Cell.new()],
         [Cell.new(),Cell.new(3,1,1)  ,Cell.new(3,2,0)  ,Cell.new(3,3,0)  ,Cell.new()],
         [Cell.new(),Cell.new()       ,Cell.new()       ,Cell.new()       ,Cell.new()]]

require 'benchmark'
puts Benchmark.measure {Board[3][1].try(1)}
(1..Rows).each{|r|
  (1..Cols).each{|c| printf("%2s",Board[r][c].value)}
  puts ""}

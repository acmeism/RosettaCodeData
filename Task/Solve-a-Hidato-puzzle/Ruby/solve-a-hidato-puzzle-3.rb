Rows = 8
Cols = 8
E = 40
$zbl = Array.new(E+1,true)
Board = [[Cell.new(),Cell.new()        ,Cell.new()        ,Cell.new()        ,Cell.new()        ,Cell.new()        ,Cell.new()        ,Cell.new()       ,Cell.new()       ,Cell.new()],
         [Cell.new(),Cell.new(1,1,0)   ,Cell.new(1,2,33)  ,Cell.new(1,3,35)  ,Cell.new(1,4,0)   ,Cell.new(1,5,0)   ,Cell.new()        ,Cell.new()       ,Cell.new()       ,Cell.new()],
         [Cell.new(),Cell.new(2,1,0)   ,Cell.new(2,2,0)   ,Cell.new(2,3,24)  ,Cell.new(2,4,22)  ,Cell.new(2,5,0)   ,Cell.new()        ,Cell.new()       ,Cell.new()       ,Cell.new()],
         [Cell.new(),Cell.new(3,1,0)   ,Cell.new(3,2,0)   ,Cell.new(3,3,0)   ,Cell.new(3,4,21)  ,Cell.new(3,5,0)   ,Cell.new(3,6,0)   ,Cell.new()       ,Cell.new()       ,Cell.new()],
         [Cell.new(),Cell.new(4,1,0)   ,Cell.new(4,2,26)  ,Cell.new(4,3,0)   ,Cell.new(4,4,13)  ,Cell.new(4,5,40)  ,Cell.new(4,6,11)  ,Cell.new()       ,Cell.new()       ,Cell.new()],
         [Cell.new(),Cell.new(5,1,27)  ,Cell.new(5,2,0)   ,Cell.new(5,3,0)   ,Cell.new(5,4,0)   ,Cell.new(5,5,9)   ,Cell.new(5,6,0)   ,Cell.new(5,7,1)  ,Cell.new()       ,Cell.new()],
         [Cell.new(),Cell.new()        ,Cell.new()        ,Cell.new(6,3,0)   ,Cell.new(6,4,0)   ,Cell.new(6,5,18)  ,Cell.new(6,6,0)   ,Cell.new(6,7,0)  ,Cell.new()       ,Cell.new()],
         [Cell.new(),Cell.new()        ,Cell.new()        ,Cell.new()        ,Cell.new()        ,Cell.new(7,5,0)   ,Cell.new(7,6,7)   ,Cell.new(7,7,0)  ,Cell.new(7,8,0)  ,Cell.new()],
         [Cell.new(),Cell.new()        ,Cell.new()        ,Cell.new()        ,Cell.new()        ,Cell.new()        ,Cell.new()        ,Cell.new(8,7,5)  ,Cell.new(8,8,0)  ,Cell.new()],
         [Cell.new(),Cell.new()        ,Cell.new()        ,Cell.new()        ,Cell.new()        ,Cell.new()        ,Cell.new()        ,Cell.new()       ,Cell.new()       ,Cell.new()]]
require 'benchmark'
puts Benchmark.measure {Board[5][7].try(1)}
(1..Rows).each{|r|
  (1..Cols).each{|c| printf("%3s",Board[r][c].value)}
  puts ""}

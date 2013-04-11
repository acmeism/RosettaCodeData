Rows = 9
Cols = 9
E = 64
$zbl = Array.new(E+1,true)
Board = [[Cell.new(),Cell.new(),Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()      ,Cell.new(),Cell.new()],
         [Cell.new(),Cell.new(),Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()      ,Cell.new(),Cell.new()],
         [Cell.new(),Cell.new(),Cell.new(2,2,0),Cell.new(2,3,0),Cell.new(2,4,0),Cell.new(2,5,0),Cell.new(2,6,0),Cell.new(2,7,0),Cell.new(2,8,0),Cell.new(2,9,0) ,Cell.new(),Cell.new()],
         [Cell.new(),Cell.new(),Cell.new(3,2,0),Cell.new(3,3,0),Cell.new(3,4,0),Cell.new(3,5,0),Cell.new(3,6,0),Cell.new(3,7,0),Cell.new(3,8,0),Cell.new(3,9,0) ,Cell.new(),Cell.new()],
         [Cell.new(),Cell.new(),Cell.new(4,2,0),Cell.new(4,3,0),Cell.new(4,4,0),Cell.new(4,5,0),Cell.new(4,6,0),Cell.new(4,7,0),Cell.new(4,8,0),Cell.new(4,9,0) ,Cell.new(),Cell.new()],
         [Cell.new(),Cell.new(),Cell.new(5,2,0),Cell.new(5,3,1),Cell.new(5,4,0),Cell.new(5,5,0),Cell.new(5,6,0),Cell.new(5,7,0),Cell.new(5,8,0),Cell.new(5,9,0) ,Cell.new(),Cell.new()],
         [Cell.new(),Cell.new(),Cell.new(6,2,0),Cell.new(6,3,0),Cell.new(6,4,0),Cell.new(6,5,0),Cell.new(6,6,0),Cell.new(6,7,0),Cell.new(6,8,0),Cell.new(6,9,0) ,Cell.new(),Cell.new()],
         [Cell.new(),Cell.new(),Cell.new(7,2,0),Cell.new(7,3,0),Cell.new(7,4,0),Cell.new(7,5,0),Cell.new(7,6,0),Cell.new(7,7,0),Cell.new(7,8,0),Cell.new(7,9,0) ,Cell.new(),Cell.new()],
         [Cell.new(),Cell.new(),Cell.new(8,2,0),Cell.new(8,3,0),Cell.new(8,4,0),Cell.new(8,5,0),Cell.new(8,6,0),Cell.new(8,7,0),Cell.new(8,8,0),Cell.new(8,9,0) ,Cell.new(),Cell.new()],
         [Cell.new(),Cell.new(),Cell.new(9,2,0),Cell.new(9,3,0),Cell.new(9,4,0),Cell.new(9,5,0),Cell.new(9,6,0),Cell.new(9,7,0),Cell.new(9,8,0),Cell.new(9,9,0),Cell.new(),Cell.new()],
         [Cell.new(),Cell.new(),Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()      ,Cell.new(),Cell.new()],
         [Cell.new(),Cell.new(),Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()     ,Cell.new()      ,Cell.new(),Cell.new()]]
require 'benchmark'
puts Benchmark.measure {Board[5][3].try(1)}
(1..Rows).each{|r|
  (1..Cols).each{|c| printf("%3s",Board[r][c].value)}
  puts ""}

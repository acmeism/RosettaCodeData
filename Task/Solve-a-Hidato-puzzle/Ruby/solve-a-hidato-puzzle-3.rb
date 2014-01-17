rows = 3
cols = 3
$end = 7
$zbl = Array.new($end+1,false)
$board = [[Cell[] ,Cell[]      ,Cell[]      ,Cell[]      ,Cell[]],
          [Cell[] ,Cell[]      ,Cell[1,2,4] ,Cell[]      ,Cell[]],
          [Cell[] ,Cell[2,1,0] ,Cell[2,2,7] ,Cell[2,3,0] ,Cell[]],
          [Cell[] ,Cell[3,1,1] ,Cell[3,2,0] ,Cell[3,3,0] ,Cell[]],
          [Cell[] ,Cell[]      ,Cell[]      ,Cell[]      ,Cell[]]]

test(rows, cols, 3, 1)

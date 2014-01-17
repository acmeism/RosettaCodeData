rows = 8
cols = 8
$end = 40
$zbl = Array.new($end+1,false)
$board = [[Cell[], Cell[]       ,Cell[]       ,Cell[]       ,Cell[]       ,Cell[]       ,Cell[]       ,Cell[]      ,Cell[]      ,Cell[]],
          [Cell[], Cell[1,1,0]  ,Cell[1,2,33] ,Cell[1,3,35] ,Cell[1,4,0]  ,Cell[1,5,0]  ,Cell[]       ,Cell[]      ,Cell[]      ,Cell[]],
          [Cell[], Cell[2,1,0]  ,Cell[2,2,0]  ,Cell[2,3,24] ,Cell[2,4,22] ,Cell[2,5,0]  ,Cell[]       ,Cell[]      ,Cell[]      ,Cell[]],
          [Cell[], Cell[3,1,0]  ,Cell[3,2,0]  ,Cell[3,3,0]  ,Cell[3,4,21] ,Cell[3,5,0]  ,Cell[3,6,0]  ,Cell[]      ,Cell[]      ,Cell[]],
          [Cell[], Cell[4,1,0]  ,Cell[4,2,26] ,Cell[4,3,0]  ,Cell[4,4,13] ,Cell[4,5,40] ,Cell[4,6,11] ,Cell[]      ,Cell[]      ,Cell[]],
          [Cell[], Cell[5,1,27] ,Cell[5,2,0]  ,Cell[5,3,0]  ,Cell[5,4,0]  ,Cell[5,5,9]  ,Cell[5,6,0]  ,Cell[5,7,1] ,Cell[]      ,Cell[]],
          [Cell[], Cell[]       ,Cell[]       ,Cell[6,3,0]  ,Cell[6,4,0]  ,Cell[6,5,18] ,Cell[6,6,0]  ,Cell[6,7,0] ,Cell[]      ,Cell[]],
          [Cell[], Cell[]       ,Cell[]       ,Cell[]       ,Cell[]       ,Cell[7,5,0]  ,Cell[7,6,7]  ,Cell[7,7,0] ,Cell[7,8,0] ,Cell[]],
          [Cell[], Cell[]       ,Cell[]       ,Cell[]       ,Cell[]       ,Cell[]       ,Cell[]       ,Cell[8,7,5] ,Cell[8,8,0] ,Cell[]],
          [Cell[], Cell[]       ,Cell[]       ,Cell[]       ,Cell[]       ,Cell[]       ,Cell[]       ,Cell[]      ,Cell[]      ,Cell[]]]

test(rows, cols, 5, 7)

graph=: ".;._2]0 :0
  0  _ _2 _  NB. 1->3 costs _2
  4  0  3 _  NB. 2->1 costs 4; 2->3 costs 3
  _  _  0 2  NB. 3->4 costs 2
  _ _1  _ 0  NB. 4->2 costs _1
)

   floyd graph
0 _1 _2 0
4  0  2 4
5  1  0 2
3 _1  1 0

   rollD7t 10         NB. 10 rolls of D7
6 4 5 1 4 2 4 5 2 5
   rollD7t 2 5        NB. 2 by 5 array of D7 rolls
5 1 5 1 3
3 4 3 5 6
   rollD7t 2 3 5      NB. 2 by 3 by 5 array of D7 rolls
4 7 7 5 7
3 7 1 4 5
5 4 5 7 6

1 1 7 6 3
4 4 1 4 4
1 1 1 6 5

NB. check results from rollD7x and rollD7t have same shape
   ($@rollD7x -: $@rollD7t) 10
1
   ($@rollD7x -: $@rollD7t) 2 3 5
1

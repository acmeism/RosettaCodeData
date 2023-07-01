   list=: 1e6 ?@$ 100           NB. 1 million random integers from 0 to 99
   freqtable=: ~. ,. #/.~       NB. verb to calculate and build frequency table
   20 (6!:2) 'freqtable list'   NB. calculate and build frequency table for list, 20 times
0.00994106

   collectedWater 5 3 7 2 6 4 5 9 1 2
14
   printTowers 5 3 7 2 6 4 5 9 1 2

       #
       #
  #~~~~#
  #~#~~#
#~#~#~##
#~#~####
###~####
########~#
##########

NB. Test cases
   TestTowers =: <@".;._2 noun define
1 5 3 7 2
5 3 7 2 6 4 5 9 1 2
2 6 3 5 2 8 1 4 2 2 5 3 5 7 4 1
5 5 5 5
5 6 7 8
8 7 7 6
6 7 10 7 6
)
   TestResults =: 2 14 35 0 0 0 0
   TestResults -: collectedWater &> TestTowers  NB. check tests
1

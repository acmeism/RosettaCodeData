   sample=: sb"0 i.1e6  NB. simulate a million mondays
   #sample              NB. number of experiments
1000000
   #;sample             NB. number of questions
1500433
   +/;sample            NB. number of heads
749617
   +/0={.@>sample       NB. how many times was sleeping beauty drugged?
500433
   (+/%#);sample        NB. odds of heads at time of question
0.4996
   sample+&#;sample     NB. total number of awakenings
2500433

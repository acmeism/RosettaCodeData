taskA=: {{
   for_j. 1+i.10 do.
     echo rplc&(' 1 steps';' 1 step')j,&":': ',(_1+#x steps y j),&":' steps.'
     echo x show y j
     echo ''
   end.
}}

taskB=: {{
   echo 'considering positive integers up to ',":m
   tallies=. _1+#@(x steps y)every 1+i.m
   echo (>./tallies) ,&": ' steps: ',&": 1+I.(=>./)tallies
   echo  ''
}}

task=:  2e4 taskB, 2e3 taskB, taskA

   1 task 2 3
1: 0 steps.
1

2: 1 step.
2-1
2/2

3: 1 step.
3/3

4: 2 steps.
4/2-1
4/2/2
4-1/3

5: 3 steps.
5-1/2-1
5-1/2/2
5-1-1/3

6: 2 steps.
6/3-1
6/3/2
6/2/3

7: 3 steps.
7-1/3-1
7-1/3/2
7-1/2/3

8: 3 steps.
8/2/2-1
8/2/2/2
8/2-1/3

9: 2 steps.
9/3/3

10: 3 steps.
10-1/3/3

considering positive integers up to 2000
14 steps: 863 1079 1295 1439 1511 1583 1607 1619 1691 1727 1823 1871 1895 1907 1919 1943

considering positive integers up to 20000
20 steps: 12959 15551 17279 18143 19439

   2 task 2 3
1: 0 steps.
1

2: 1 step.
2/2

3: 1 step.
3-2
3/3

4: 2 steps.
4-2/2
4/2/2

5: 2 steps.
5-2-2
5-2/3

6: 2 steps.
6/2-2
6/3/2
6/2/3

7: 3 steps.
7-2-2-2
7-2-2/3

8: 3 steps.
8-2/2-2
8/2-2/2
8/2/2/2
8-2/3/2
8-2/2/3

9: 2 steps.
9/3-2
9/3/3

10: 3 steps.
10/2-2-2
10/2-2/3

considering positive integers up to 2000
17 steps: 1699

considering positive integers up to 20000
24 steps: 19681

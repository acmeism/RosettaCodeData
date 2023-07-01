   fy=: (%16) * [: *: 4 + *:             NB. f(t,y)
   fyp=: (* %:)/                         NB. f'(t,y)
   report_whole=: (10 * i. >:10)&{       NB. report at whole-numbered t values
   report_err=: (, {: - [: fy {.)"1      NB. report errors

   report_err report_whole fyp rk4 1 0 10 0.1
 0       1           0
 1  1.5625 _1.45722e_7
 2       4 _9.19479e_7
 3 10.5625 _2.90956e_6
 4      25 _6.23491e_6
 5 52.5625 _1.08197e_5
 6     100 _1.65946e_5
 7 175.562 _2.35177e_5
 8     289 _3.15652e_5
 9 451.562 _4.07232e_5
10     676 _5.09833e_5

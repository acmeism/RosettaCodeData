   + / 3 1 4 1 5 9   NB. sum
23
   >./ 3 1 4 1 5 9   NB. max
9
   *./ 3 1 4 1 5 9   NB. lcm
180

   +/\ 3 1 4 1 5 9   NB. sum prefix (partial sums)
3 4 8 9 14 23

   +/\. 3 1 4 1 5 9  NB. sum suffix
23 20 19 15 14 9

   2&% 1 2 3         NB. divide 2 by
2 1 0.666667

   %&2 (1 2 3)       NB. divide by 2 (need parenthesis to break up list formation)
0.5 1 1.5
   -: 1 2 3          NB. but divide by 2 happens a lot so it's a primitive
0.5 1 1.5

   f=: -:@(+ 2&%)    NB. one Newton iteration
   f 1
1.5
   f f 1
1.41667

   f^:(i.5) 1        NB. first 5 Newton iterations
1 1.5 1.41667 1.41422 1.41421
   f^:(i.5) 1x       NB. rational approximations to sqrt 2
1 3r2 17r12 577r408 665857r470832

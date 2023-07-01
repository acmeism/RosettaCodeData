   line1=: 4 0 ,: 6 10
   line2=: 0 3 ,: 10 7
   line3=: 0 3 ,: 10 7.1
   line4=: 0 0 ,: 1 1
   line5=: 1 2 ,: 4 5
   line6=: 1 _1 ,: 4 4
   line7=: 2 5 ,: 3 _2

   findIntersection line1 ,: line2
5 5
   findIntersection line1 ,: line3
5.01089 5.05447
   findIntersection line4 ,: line5
__ __
   findIntersection line6 ,: line7
2.5 1.5

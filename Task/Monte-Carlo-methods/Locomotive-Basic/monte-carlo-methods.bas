10 mode 1:randomize time:defint a-z
20 input "How many samples";n
30 u=n/100+1
40 r=100
50 for i=1 to n
60 if i mod u=0 then locate 1,3:print using "##% done"; i/n*100
70 x=rnd*2*r-r
80 y=rnd*2*r-r
90 if sqr(x*x+y*y)<r then m=m+1
100 next
110 pi2!=4*m/n
120 locate 1,3
130 print m;"points in circle"
140 print "Computed value of pi:"pi2!
150 print "Difference to real value of pi: ";
160 print using "+#.##%"; (pi2!-pi)/pi*100

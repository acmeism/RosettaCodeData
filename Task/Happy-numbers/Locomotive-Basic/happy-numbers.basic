10 mode 1:defint a-z
20 for i=1 to 100
30 i2=i
40 for l=1 to 20
50 a$=str$(i2)
60 i2=0
70 for j=1 to len(a$)
80 d=val(mid$(a$,j,1))
90 i2=i2+d*d
100 next j
110 if i2=1 then print i;"is a happy number":n=n+1:goto 150
120 if i2=4 then 150 ' cycle found
130 next l
140 ' check if we have reached 8 numbers yet
150 if n=8 then end
160 next i

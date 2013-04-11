10 mode 1:defint a-z:deg
20 ink 1,0:ink 0,26
30 x=50:y=50:ang=270
40 dim play(100,100)
50 graphics pen 3:move 220,100:drawr 200,0:drawr 0,200:drawr -200,0:drawr 0,-200
60 ' move ant
70 if play(x,y) then ang=ang-90 else ang=ang+90
80 play(x,y)=1-play(x,y)
90 plot 220+2*x,100+2*y,play(x,y)
100 ang=ang mod 360
110 x=x+sin(ang)
120 y=y+cos(ang)
130 if x<1 or x>100 or y<1 or y>100 then end
140 goto 70

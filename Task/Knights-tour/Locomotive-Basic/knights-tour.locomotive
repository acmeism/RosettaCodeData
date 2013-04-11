10 mode 1:defint a-z
20 input "Board size: ",size
30 input "Start position: ",a$
40 x=asc(mid$(a$,1,1))-96
50 y=val(mid$(a$,2,1))
60 dim play(size,size)
70 for q=1 to 8
80 read dx(q),dy(q)
90 next
100 data 2,1,1,2,-1,2,-2,1,-2,-1,-1,-2,1,-2,2,-1
110 pen 0:paper 1
120 for q=1 to size
130 locate 3*q+1,24-size
140 print chr$(96+q);
150 locate 3*(size+1)+1,26-q
160 print using "#"; q;
170 next
180 pen 1:paper 0
190 ' main loop
200 n=n+1
210 play(x,y)=n
220 locate 3*x,26-y
230 print using "##"; n;
240 if n=size*size then call &bb06:end
250 nmov=100
260 for q=1 to 8
270 xc=x+dx(q)
280 yc=y+dy(q)
290 gosub 360
300 if nm<nmov then nmov=nm:qm=q
310 next
320 x=x+dx(qm)
330 y=y+dy(qm)
340 goto 200
350 ' find moves
360 if xc<1 or yc<1 or xc>size or yc>size then nm=1000:return
370 if play(xc,yc) then nm=2000:return
380 nm=0
390 for q2=1 to 8
400 xt=xc+dx(q2)
410 yt=yc+dy(q2)
420 if xt<1 or yt<1 or xt>size or yt>size then 460
430 if play(xt,yt) then 460
440 nm=nm+1
450 ' skip this move
460 next
470 return

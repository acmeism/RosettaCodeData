10 mode 1:randomize time
20 defint a-z
30 boardx=6:boardy=4
40 dim a(boardx,boardy)
50 dim c(boardx+2,boardy+2)
60 dim c2(boardx+2,boardy+2)
70 nmines=int((rnd/3+.1)*boardx*boardy)
80 for i=1 to nmines
90 ' place random mines
100 xp=int(rnd*(boardx-1)+1)
110 yp=int(rnd*(boardy-1)+1)
120 if a(xp,yp) then 100
130 a(xp,yp)=64
140 for xx=xp to xp+2
150 for yy=yp to yp+2
160 c(xx,yy)=c(xx,yy)+1
170 next yy
180 next xx
190 next i
200 gosub 350
210 x=1:y=1
220 gosub 600
230 ' wait for key press
240 k$=lower$(inkey$)
250 if k$="" then 240
260 if k$="q" and y>1 then gosub 660:y=y-1:gosub 600
270 if k$="a" and y<boardy then gosub 660:y=y+1:gosub 600
280 if k$="o" and x>1 then gosub 660:x=x-1:gosub 600
290 if k$="p" and x<boardx then gosub 660:x=x+1:gosub 600
300 if k$="m" then a(x,y)=a(x,y) xor 128:gosub 600:gosub 1070
310 if k$=" " then a(x,y)=a(x,y) or 512:gosub 700:sx=x:sy=y:gosub 450:x=sx:y=sy:gosub 600
320 goto 240
330 end
340 ' print board
350 mode 1
360 gosub 450
370 locate 1,12
380 print "Move on the board with the Q,A,O,P keys"
390 print "Press Space to clear"
400 print "Press M to mark as a potential mine"
410 print
420 print "There are"nmines"mines."
430 return
440 ' update board
450 for y=1 to boardy
460 for x=1 to boardx
470 locate 2*x,y
480 gosub 530
490 next
500 next
510 return
520 ' print tile
530 if a(x,y) and 128 then print "?":return
540 if c(x+1,y+1)=0 then d$=" " else d$=chr$(c(x+1,y+1)+48)
550 if a(x,y) and 256 then print d$:return
560 'if a(x,y) and 64 then print "M":return
570 print "."
580 return
590 ' turn on tile
600 locate 2*x,y
610 pen 0:paper 1
620 gosub 530
630 pen 1:paper 0
640 return
650 ' turn off tile
660 locate 2*x,y
670 gosub 530
680 return
690 ' clear tile
700 if a(x,y) and 64 then locate 15,20:print "*** BOOM! ***":end
710 locate 1,25:print "-WAIT-";
720 for x2=1 to boardx
730 for y2=1 to boardy
740 c2(x2+1,y2+1)=a(x2,y2)
750 next
760 next
770 ' iterate clearing
780 cl=0
790 for x2=1 to boardx
800 for y2=1 to boardy
810 if c2(x2+1,y2+1) and 512 then gosub 940:cl=cl+1
820 next y2
830 next x2
840 if cl then 780
850 for x2=1 to boardx
860 for y2=1 to boardy
870 vv=c2(x2+1,y2+1)
880 if vv>1000 then a(x2,y2)=vv xor 1024
890 next y2
900 next x2
910 locate 1,25:print "      ";
920 return
930 ' find neighbors
940 c2(x2+1,y2+1)=(c2(x2+1,y2+1) xor 512) or 256 or 1024
950 for ii=0 to 2
960 for jj=0 to 2
970 if ii=0 and jj=0 then 1030
980 if c2(x2+ii,y2+jj) and 64 then 1030
990 if c2(x2+ii,y2+jj) and 128 then 1030
1000 if c2(x2+ii,y2+jj) and 1024 then 1030
1010 c2(x2+ii,y2+jj)=c2(x2+ii,y2+jj) or 512
1020 ' next tile
1030 next jj
1040 next ii
1050 return
1060 ' update discovered mine count
1070 mm=0
1080 for x2=1 to boardx
1090 for y2=1 to boardy
1100 if (a(x2,y2) and 128)>0 and (a(x2,y2) and 64)>0 then mm=mm+1
1110 next
1120 next
1130 if mm=nmines then locate 5,22:print "Congratulations, you've won!":end
1140 return

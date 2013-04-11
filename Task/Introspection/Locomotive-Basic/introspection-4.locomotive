10 ' The program should find and add those three integers (%), ignoring reals:
20 foo%=-4:bar%=7:baz%=9:somereal=3.141
30 varstart=&ae68   ' for CPC 664 and 6128
40 ' varstart=&ae85 ' (use this line instead on the CPC 464)
50 start=PEEK(varstart)+256*PEEK(varstart+1)
60 WHILE start<HIMEM
70 j=2:WHILE j<43 ' skip variable name
80 IF PEEK(start+j)=0 GOTO 170
90 IF PEEK(start+j)>127 THEN ptr=start+j+1:j=100
100 j=j+1:WEND
110 vartype=PEEK(ptr) ' integer=1, string=2, real=4
120 IF vartype=1 THEN sum=sum+UNT(PEEK(ptr+1)+256*PEEK(ptr+2)):num=num+1:nvar=ptr+3
130 IF vartype=2 THEN nvar=ptr+4
140 IF vartype=4 THEN nvar=ptr+6
150 start=nvar
160 WEND
170 PRINT "There are"num"integer variables."
180 PRINT "Their sum is"sum

10 s=&4000:SYMBOL AFTER 256:MEMORY s-1
20 FOR i=0 to 34:READ a:POKE s+i,a:NEXT
30 DATA &c5,&d5,&e5,&f5,&01,&00,&df,&ed,&49,&01,&86,&7f,&ed,&49
40 DATA &21,&01,&c0,&11,&40,&40,&01,&03,&00,&ed,&b0
50 DATA &01,&8e,&7f,&ed,&49,&f1,&e1,&d1,&c1,&c9
60 CALL s
70 PRINT "BASIC ROM version is ";PEEK(&4040);".";PEEK(&4041);".";PEEK(&4042)
80 IF PEEK(&4041)=0 THEN PRINT "Uh oh, you are still using BASIC 1.0":END
90 PRINT "You are using BASIC 1.1 or later, program can continue"

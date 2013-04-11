10 CLS:RANDOMIZE TIME
20 PRINT "The 24 Game"
30 PRINT "===========":PRINT
40 PRINT "Enter an arithmetic expression"
50 PRINT "that evaluates to 24,"
60 PRINT "using only the provided digits"
70 PRINT "and +, -, *, /, (, )."
80 PRINT "(Just hit Return for new digits.)"
90 ' create new digits
100 FOR i=1 TO 4:a(i)=INT(RND*9)+1:NEXT
110 PRINT
120 PRINT "The digits are";a(1);a(2);a(3);a(4)
130 PRINT
140 ' user enters solution
150 INPUT "Your solution";s$
160 IF s$="" THEN PRINT "Creating new digits...":GOTO 100
170 GOTO 300
180 ' a little hack to create something like an EVAL function
190 OPENOUT "exp.bas"
200 PRINT #9,"1000 x="s$":return"
210 CLOSEOUT
220 CHAIN MERGE "exp",240
230 ' now evaluate the expression
240 ON ERROR GOTO 530
250 GOSUB 1000
260 IF x=24 THEN PRINT "Well done!":END
270 PRINT "No, this evaluates to"x:PRINT "Please try again."
280 GOTO 150
290 ' check input for correctness
300 FOR i=1 TO LEN(s$)
310 q=ASC(MID$(s$,i,1))
320 IF q=32 OR (q>39 AND q<44) OR q=45 OR (q>46 AND q<58) THEN NEXT
330 IF i-1=LEN(s$) THEN 370
340 PRINT "Bad character in expression:"CHR$(q)
350 PRINT "Try again":GOTO 150
360 ' new numbers in solution?
370 FOR i=1 TO LEN(s$)-1
380 q=ASC(MID$(s$,i,1)):p=ASC(MID$(s$,i+1,1))
390 IF q>47 AND q<58 AND p>47 AND p<58 THEN PRINT "No forming of new numbers, please!":GOTO 150
400 NEXT
410 FOR i=1 TO 9:orig(i)=0:guess(i)=0:NEXT
420 FOR i=1 TO 4:orig(a(i))=orig(a(i))+1:NEXT
430 FOR i=1 TO LEN(s$)
440 v$=MID$(s$,i,1)
450 va=ASC(v$)-48
460 IF va>0 AND va<10 THEN guess(va)=guess(va)+1
470 NEXT
480 FOR i=1 TO 9
490 IF guess(i)<>orig(i) THEN PRINT "Only use all the provided digits!":GOTO 150
500 NEXT
510 GOTO 190
520 ' syntax error, e.g. non-matching parentheses
530 PRINT "Error in expression, please try again."
540 RESUME 150

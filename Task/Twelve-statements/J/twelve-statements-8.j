'sum not mask'=: |:".;._2(0 :0)
   0; 0; 0 0 0 0 0 0 0 0 0 0 0 0   NB. 1.  This is a numbered list of twelve statements.
   3; 0; 0 0 0 0 0 0 1 1 1 1 1 1   NB. 2.  Exactly 3 of the last 6 statements are true.
   2; 0; 0 1 0 1 0 1 0 1 0 1 0 1   NB. 3.  Exactly 2 of the even-numbered statements are true.
   2; 5; 0 0 0 0 0 1 1 0 0 0 0 0   NB. 4.  If statement 5 is true, then statements 6 and 7 are both true.
   0; 0; 0 1 1 1 0 0 0 0 0 0 0 0   NB. 5.  The 3 preceding statements are all false.
   4; 0; 1 0 1 0 1 0 1 0 1 0 1 0   NB. 6.  Exactly 4 of the odd-numbered statements are true.
   1; 0; 0 1 1 0 0 0 0 0 0 0 0 0   NB. 7.  Either statement 2 or 3 is true, but not both.
   2; 7; 0 0 0 0 1 1 0 0 0 0 0 0   NB. 8.  If statement 7 is true, then 5 and 6 are both true.
   3; 0; 1 1 1 1 1 1 0 0 0 0 0 0   NB. 9.  Exactly 3 of the first 6 statements are true.
   2; 0; 0 0 0 0 0 0 0 0 0 0 1 1   NB. 10. The next two statements are both true.
   1; 0; 0 0 0 0 0 0 1 1 1 0 0 0   NB. 11. Exactly 1 of statements 7, 8 and 9 are true.
   4; 0; 1 1 1 1 1 1 1 1 1 1 1 0   NB. 12. Exactly 4 of the preceding statements are true.
)
propositions=: |:#:i.2^#sum

errors=: propositions~:(1 - not { 1,propositions) >. sum = mask +/ .*propositions

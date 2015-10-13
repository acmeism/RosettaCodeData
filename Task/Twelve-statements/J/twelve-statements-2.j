S=: <;._2 (0 :0)
 12&=@#                   NB. 1.  This is a numbered list of twelve statements.
 3=+/@:{.~&_6             NB. 2.  Exactly 3 of the last 6 statements are true.
 2= +/@:{~&1 3 5 7 9 11   NB. 3.  Exactly 2 of the even-numbered statements are true.
 4&{=*./@:{~&4 5 6        NB. 4.  If statement 5 is true, then statements 6 and 7 are both true.
 0=+/@:{~&1 2 3           NB. 5.  The 3 preceding statements are all false.
 4=+/@:{~&0 2 4 6 8 10    NB. 6.  Exactly 4 of the odd-numbered statements are true.
 1=+/@:{~&1 2             NB. 7.  Either statement 2 or 3 is true, but not both.
 6&{=*./@:{~&4 5 6        NB. 8.  If statement 7 is true, then 5 and 6 are both true.
 3=+/@:{.~&6              NB. 9.  Exactly 3 of the first 6 statements are true.
 2=+/@:{~&10 11           NB. 10. The next two statements are both true.
 1=+/@:{~&6 7 8           NB. 11. Exactly 1 of statements 7, 8 and 9 are true.
 4=+/@:{.~&11             NB. 12. Exactly 4 of the preceding statements are true.
)

testall=: (];"1 0<@I.@:(]~:(apply&><))"1) #:@i.@(2&^)@#

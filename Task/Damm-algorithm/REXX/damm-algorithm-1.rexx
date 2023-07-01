/* REXX */
Call init
Call test 5724
Call test 5727
Call test 112946
Call test 112940
Exit

test:
Parse Arg number
int_digit=0
Do p=1 To length(number)
  d=substr(number,p,1)
  int_digit=grid.int_digit.d
  If p<length(number) Then cd=int_digit
  End
If int_digit=0 Then
  Say number 'is ok'
Else
  Say number 'is not ok, check-digit should be' cd '(instead of' d')'
Return

init:
i=-2
Call setup '* 0 1 2 3 4 5 6 7 8 9'
Call setup '0 0 3 1 7 5 9 8 6 4 2'
Call setup '1 7 0 9 2 1 5 4 8 6 3'
Call setup '2 4 2 0 6 8 7 1 3 5 9'
Call setup '3 1 7 5 0 9 8 3 4 2 6'
Call setup '4 6 1 2 3 0 4 5 9 7 8'
Call setup '5 3 6 7 4 2 0 9 5 8 1'
Call setup '6 5 8 6 9 7 2 0 1 3 4'
Call setup '7 8 9 4 5 3 6 2 0 1 7'
Call setup '8 9 4 3 8 6 1 7 2 0 5'
Call setup '9 2 5 8 1 4 3 6 7 9 0'
Return
setup:
  Parse Arg list
  i=i+1
  Do col=-1 To 9
    grid.i.col=word(list,col+2)
    End
  Return

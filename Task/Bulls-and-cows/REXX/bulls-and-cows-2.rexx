/*REXX program to play the game of  "Bulls & Cows". *******************
* Changes from Version 1:
* ?= -> qq='' (righthandside mandatory and I never use ? as symbol -
*                               although it is available on all Rexxes)
* implemented singular/plural distinction differently
* change getRand to avoid invalid digit rejection
* check user's input for multiple digits
* add feature MM to ease guessing (MM=Mastermind - a similar game)
* add feature ? to see the solution (for the impatient player)
* program runs as is on ooRexx and on TSO (after changing | to !)
* Made source and output more compact
* formatted source 'my way'  2 July 2012 Walter Pachl
**********************************************************************/
ask='<Bulls & Cows game>   Please enter a four-digit guess  (or QUIT):'

b.='bulls'; b.1='bull'
c.='cows';  c.1='cow'
qq=getRand()
mm=0
Do Forever
  If get_guess()==qq Then leave
  Call scorer
  Say "You got" bulls b.bulls "and" cows c.cows"."
  If mm Then
    Say mms
  End   /*forever*/
Say "         *******************************************"
Say "         *                                         *"
Say "         *  Congratulations, you've guessed it !!  *"
Say "         *                                         *"
Say "         *******************************************"
Exit

get_guess:                           /*get a guess from the guesser. */

do forever
  Say ask
  Parse Pull guessi
  guess=translate(guessi)
  bc=verify(guess,987654321)
  Select
    When guess='?'       Then Say qq 'is the correct sequence'
    When guess='QUIT'    Then Exit
    When guess='MM'      Then Do
                              Say 'Mastermind output enabled'
                              mm=1
                              End
    When guess=''        Then Call ser 'no argument specified.'
    When words(guess)>1  Then Call ser 'too many arguments specified.'
    When verify(0,guess)=0 Then Call ser 'illegal digit: 0'
    When bc>0 Then Call ser 'illegal character:' substr(guessi,bc,1)
    When length(guess)<4 Then Call ser 'not enough digits'
    When length(guess)>4 Then Call ser 'too many digits'
    When dups(guess)     Then Call ser '4 DIFFERENT digits, please'
    Otherwise Do
      /********** Say guess ************/
      Return guess
      End
    End
  End

getRand:
digits='123456789'
qq=''
Do i=1 To 4
  d=random(1,length(digits))
  d=substr(digits,d,1)
  qq=qq||d
  digits=space(translate(digits,' ',d),0)
  /************ Say qq digits ************/
  End
Return qq

scorer: g=qq
mms='----'
bulls=0
Do j=1 for 4
  If substr(guess,j,1)=substr(qq,j,1) Then Do
    bulls=bulls+1
    guess=overlay(' ',guess,j)
    mms=overlay('+',mms,j)
    End
  End
cows=0
Do j=1 To 4
  If pos(substr(guess,j,1),qq)>0 Then Do
    cows=cows+1
    mms=overlay('.',mms,j)
    End
  End
Return

dups: Procedure
Parse Arg s
Do i=1 To 3
  If pos(substr(s,i,1),substr(s,i+1))>0 Then
    Return 1
  End
Return 0

ser: Say '*** error ***' arg(1); Return

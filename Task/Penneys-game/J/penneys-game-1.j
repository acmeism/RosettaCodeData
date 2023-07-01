require 'format/printf numeric'

randomize ''                               NB. randomize seed for new session

Vals=: 'HT'                                NB. valid values
input=: 1!:1@<&1:                          NB. get input from user
prompt=: input@echo                        NB. prompt user for input
checkInput=: 'Choose 3 H/Ts' assert (Vals e.~ ]) , 3 = #
getUserSeq=: (] [ checkInput)@toupper@prompt
choose1st=: Vals {~ 3 ?@$ 2:               NB. computer chooses 1st
choose2nd=: (0 1 1=1 0 1{])&.(Vals&i.)     NB. computer chooses 2nd

playPenney=: verb define
  if. ?2 do.                               NB. randomize first chooser
    Comp=. choose1st ''
    'Computer chose %s' printf <Comp
    You=. getUserSeq 'Choose a sequence of three coin tosses (H/T):'
    'Choose a different sequence to computer' assert You -.@-: Comp
  else.
    You=. getUserSeq 'Choose a sequence of three coin tosses (H/T):'
    Comp=. choose2nd You
    'Computer chose %s ' printf <Comp
  end.
  Tosses=. Vals {~ 100 ?@$ 2
  Result=. (Comp,:You) {.@I.@E."1 Tosses
  'Toss sequence is %s' printf < (3 + <./ Result) {. Tosses
  echo ('No result';'You win!';'Computer won!') {::~ *-/ Result
)

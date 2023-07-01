NB. Quick and dirty tacit toolkit...

o=. @:
c=."_

ver=. (0:`)([:^:)

d=. (fix=. (;:'f.')ver) (train=.(;:'`:')ver&6) (an=. <@:((,'0') (,&<) ]))
ver=. (an f. o fix'ver')ver o an f.
z=. ((an'')`($ ,)`) (`:6)
d=. (a0=. `'') (a1=. (@[) ((<'&')`) (`:6)) (a2=. (`(<(":0);_)) (`:6))
av=. ((an o fix'a0')`)  (`(an o fix'a1')) (`(an o fix'a2') ) (`:6)

Fetch=. (ver o train ;:'&{::')&.> o i. f.av
tie=. ver o train ;:'`'

indices=. (, $~ 1 -.~ $) o (train"0 o ((1 -: L.)S:1 # <S:1) o (tie&'') o fix :: ])
f=. ((ver o train ;:'&{')) o indices o train f.av

'A B'=. 2 Fetch
head=. (;:'<@:') {.~ 2 * 1 = #@[
h=. train o (indices o train o (A f) (head , (B f)@] , < o an@[  , (;:'}]')c) ]) f.av

DropIfNB=. < o ('('"_ , ] , ')'"_) o ((}: ^: ('NB.' -: 3&{. o > o {:)) &. ;:)
pipe=. ([ , ' o ' , ])&:>/ o |.

is=. ". o (, o ": o > , '=. ' , pipe o (DropIfNB;._2) o ". o ('0 ( : 0)'c)) f.av

NB.--------------------------------------------------------------------------------------

NB. Producing the verb simulate...

Note 0

NB. X and Y...
  N - Philosophers names
  C - Number of chronological events to simulate

NB. Local...
  A - Activity (0 - Thinking, 1 -eating, 2 - Thinking while queuing,)
  B - New activity
  T - Residual time left for the activity
  S - Starting time for the new activity
  Q - Queue
  U - Upper bound for the number of philosophers who can eat simultaneously
  P - Active philosopher
  E - Elapsed Time (only for information purposes)
)

amend=. 0 (0 {:: ])`(<@:(1 {:: ]))`(2 {:: ])} ]

'N C A B T S Q U P E'=. 10 Fetch  NB. 10 Boxes

thinktime=. _1 * ^. o ? o 0:  NB. Exponentially distributed at a rate of one
eattime  =. _2 * ^. o ? o 0:  NB. Exponentially distributed at a rate of one-half
j=. ,&<

time=. (6j3 ": E) , ': 'c

start is
  (N Q)`((;: o N) j (''c))            h NB. Boxing the names, empty queue
  (A T)`((0:items j thinktime&>) o N) h NB. All start thinking
  (E U)`(0 ; <. o (2 %~ # o N))       h NB. Elapsed time 0, Upper bound
  [ echo o (time , 'All of them start thinking.'c)
)

CanEat=. U > 1 +/ o = A   NB. Can eat if there is a suitable place at the table

eat is
  T`(amend o ((S P T)f))h o (S`eattime h)  NB. Eating time
  A`(amend o ((B P A)f))h o (B`1:      h)  NB. Activity: eating
  [ echo o (time , ' starts eating.' ,~ P {:: N)
)

enqueue is
  T`(amend o ((S P T)f))h o (S`_:h) NB. Inactive until someone else ends eating
  A`(amend o ((B P A)f))h o (B`2:h) NB. Activity: thinking while queuing
  Q`(Q , P)h                        NB. Enqueuing
  [ echo o (time , ' starts waiting and thinking about hunger.' ,~ P {:: N)
)

thinking=. enqueue`eat@.CanEat  NB. Either enqueues or eats after thinking

dequeue is
  P`({. o Q)h  NB. Activating the one in front of the queue
  eat          NB. and starts eating
  Q`(}. o Q)h  NB. dequeuing
)

eating is  NB. Thinks after eating
  T`(amend o ((S P T)f))h o (S`thinktime h) NB. Thinking time
  A`(amend o ((B P A)f))h o (B`0:        h) NB. Activity: thinking
  [ echo o ( time , ' starts thinking.' ,~ P {:: N)
  dequeue ^: (1 <: # o Q)     NB. Dequeuing a philosopher (if possible)
)

update is
  E`(E + <./ o T)h            NB. Updating the elapsed time
  T`((- <./)@:T) h            NB. Updating the residual times
  P`(0 I. o = T) h            NB. Setting the active philosopher
  thinking`eating@.((P { A)z) NB. Was thinking or eating?
  C`(1 -~ C)     h            NB. One chronological event completed
)

simulate is NB. Discrete event simulation (dyadic verb)
  ;                           NB. Linking the arguments (N C)
  ,&(;:8$',')                 NB. Appending 8 local boxes (A B T S Q U P E)
  start
  update ^: (0 < C) ^: _      NB. Updating while events are less than C
  ''c
)

simulate=. simulate f.

NB. The simulation code is produced by the sentence,
NB. 77 (-@:[ ]\ 5!:5@<@:]) 'simulate'

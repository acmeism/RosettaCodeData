: anEvent
| ch |
   Channel new ->ch
   #[ ch receive "Ok, event is signaled !" println ] &
   System sleep(1000)
   ch send($myEvent) ;

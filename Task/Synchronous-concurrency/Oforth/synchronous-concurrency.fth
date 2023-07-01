import: parallel

: printing(chPrint, chCount)
  0 while( chPrint receive dup notNull ) [ println 1+ ] drop
  chCount send drop ;

: concurrentPrint(aFileName)
| chPrint chCount line |
   Channel new ->chPrint
   Channel new ->chCount

   #[ printing(chPrint, chCount) ] &

   aFileName File new forEach: line [ chPrint send(line) drop ]
   chPrint close
   chCount receive "Number of lines printed : " print println ;

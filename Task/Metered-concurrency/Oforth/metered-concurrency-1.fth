import: parallel

Object Class new: Semaphore(ch)

Semaphore method: initialize(n)
   Channel newSize(n) dup := ch
   #[ 1 over send drop ] times(n) drop ;

Semaphore method: acquire  @ch receive drop ;
Semaphore method: release  1 @ch send drop ;

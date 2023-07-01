Object Class new: Sequence(channel)
Sequence method: initialize(initialValue)
   Channel newSize(1) := channel
   @channel send(initialValue) drop ;

Sequence method: nextValue  @channel receive dup 1 + @channel send drop ;

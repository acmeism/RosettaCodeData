   list=: 0 2$a: NB. creates list with 0 items
   list
   list=: ,: (<_) , <'some text' NB. creates list with 1 item
   list
+-+---------+
|_|some text|
+-+---------+

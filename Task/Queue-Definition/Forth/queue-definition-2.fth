0
  field: list-next
  field: list-val
constant list-struct

: insert ( x list-addr -- )
    list-struct allocate throw >r
    swap r@ list-val !
    dup @ r@ list-next !
    r> swap ! ;

: remove ( list-addr -- x )
    >r r@ @ ( list-node )
    r@ @ dup list-val @ ( list-node x )
    swap list-next @ r> !
    swap free throw ;

0
  field: queue-last \ points to the last entry (head of the list)
  field: queue-nextaddr \ points to the pointer to the next-inserted entry
constant queue-struct

: init-queue ( queue -- )
    >r 0 r@ queue-last !
    r@ queue-last r> queue-nextaddr ! ;

: make-queue ( -- queue )
    queue-struct allocate throw dup init-queue ;

: empty? ( queue -- f )
    queue-last @ 0= ;

: enqueue ( x queue -- )
    dup >r queue-nextaddr @ insert
    r@ queue-nextaddr @ @ list-next r> queue-nextaddr ! ;

: dequeue ( queue -- x )
    dup empty? abort" dequeue applied to an empty queue"
    dup queue-last remove ( queue x )
    over empty? if
        over init-queue then
    nip ;

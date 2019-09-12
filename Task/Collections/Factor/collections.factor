USING: assocs deques dlists lists lists.lazy sequences sets ;

! ===fixed-size sequences===
{ 1 2 "foo" 3 } ! array
[ 1 2 3 + * ]   ! quotation
"Hello, world!" ! string
B{ 1 2 3 }      ! byte array
?{ f t t }      ! bit array

! Add an element to a fixed-size sequence
{ 1 2 3 } 4 suffix ! { 1 2 3 4 }

! Append a sequence to a fixed-size sequence
{ 1 2 3 } { 4 5 6 } append ! { 1 2 3 4 5 6 }

! Sequences are sets
{ 1 1 2 3 } { 2 5 7 8 } intersect ! { 2 }

! Strings are just arrays of code points
"Hello" { } like ! { 72 101 108 108 111 }
{ 72 101 108 108 111 } "" like ! "Hello"

! ===resizable sequences===
V{ 1 2 "foo" 3 }     ! vector
BV{ 1 2 255 }        ! byte vector
SBUF" Hello, world!" ! string buffer

! Add an element to a resizable sequence by mutation
V{ 1 2 3 } 4 suffix! ! V{ 1 2 3 4 }

! Append a sequence to a resizable sequence by mutation
V{ 1 2 3 } { 4 5 6 } append! ! V{ 1 2 3 4 5 6 }

! Sequences are stacks
V{ 1 2 3 } pop ! 3

! ===associative mappings===
{ { "hamburger" 150 } { "soda" 99 } { "fries" 99 } } ! alist
H{ { 1 "a" } { 2 "b" } } ! hash table

! Add a key-value pair to an assoc
3 "c" H{ { 1 "a" } { 2 "b" } } [ set-at ] keep
! H{ { 1 "a" } { 2 "b" } { "c" 3 } }

! ===linked lists===
T{ cons-state f 1 +nil+ }               ! literal list syntax
T{ cons-state { car 1 } { cdr +nil+ } } ! literal list syntax
                                        ! with car 1 and cdr nil

! One method of manually constructing a list
1 2 3 4 +nil+ cons cons cons cons

1 2 2list ! convenience word for list construction
          ! T{ cons-state
          !     { car 1 }
          !     { cdr T{ cons-state { car 2 } { cdr +nil+ } } }
          !  }

{ 1 2 3 4 } sequence>list ! make a list from a sequence

0 lfrom ! a lazy list from 0 to infinity
0 [ 2 + ] lfrom-by ! a lazy list of all even numbers >= 0.

DL{ 1 2 3 } ! double linked list / deque
3 DL{ 1 2 } [ push-front ] keep ! DL{ 3 1 2 }
3 DL{ 1 2 } [ push-back  ] keep ! DL{ 1 2 3 }

! Factor also comes with disjoint sets, interval maps, heaps,
! boxes, directed graphs, locked I/O buffers, trees, and more!

car=: 0{::]
cdr=: 1{::]
list2linkedlist=: ]`(car;<@$:@}.)@.(*@#)
reverselinkedlist=: '' {{x [`((car;<@[) $: cdr)@.(*@#@]) y }} ]

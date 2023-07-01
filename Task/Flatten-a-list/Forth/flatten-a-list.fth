include FMS-SI.f
include FMS-SILib.f

: flatten {: list1 list2 --  :}
  list1 size: 0 ?do i list1 at:
                  dup is-a object-list2
                  if list2 recurse else list2 add: then  loop ;

object-list2 list
o{ o{ 1 } 2 o{ o{ 3 4 } 5 } o{ o{ o{ } } } o{ o{ o{ 6 } } } 7 8 o{ } }
list flatten
list p: \ o{ 1 2 3 4 5 6 7 8 } ok

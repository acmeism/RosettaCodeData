include FMS-SI.f
include FMS-SILib.f

\ Since the same join attribute, Name, occurs more than once
\ in both tables for this problem we need a hash table that
\ will accept and retrieve multiple identical keys if we want
\ an efficient solution for large tables. We make use
\ of the hash collision handling feature of class hash-table.

\ Subclass hash-table-m allows multiple entries with the same key.
\ After a get: hit one can inspect for additional entries with
\ the same key by using next: until false is returned.

:class hash-table-m <super hash-table

\ called within insert: method in superclass
 :m (do-search): ( node hash -- idx hash false )
      swap drop idx @ swap false ;m
 :m next: ( -- val true | false )
    last-node @ dup
    if
      begin
       ( node ) next: dup
      while
        dup key@: @: key-addr @ key-len @ compare 0=
             if dup last-node ! val@: true exit then
      repeat
    then ;m
;class

\ begin hash phase
: obj ( addr len -- obj )
  heap> string+ dup >r !: r> ;

hash-table-m R   1 r init
s" Whales "   obj s" Jonah" r insert:
s" Spiders "  obj s" Jonah" r insert:
s" Ghosts "   obj s" Alan"  r insert:
s" Buffy "    obj s" Glory" r insert:
s" Zombies "  obj s" Alan"  r insert:
s" Vampires " obj s" Jonah" r insert:
\ end hash phase

\ create Age Name table S
o{ o{ 27 'Jonah' }
   o{ 18 'Alan' }
   o{ 28 'Glory' }
   o{ 18 'Popeye' }
   o{ 28 'Alan' } } value s

\ Q is a place to store the relation
object-list2 Q

\ join phase
: join \ { obj | list -- }
  0 locals| list obj |
  1 obj at: @: r get: \ hash the join-attribute and search table r
  if \ we have a match, so concatenate and save in q
    heap> object-list2 to list list q add: \ start a new sub-list in q
    0 obj at: copy: list add: \ place age from list s in q
    1 obj at: copy: list add: \ place join-attribute (name) from list s in q
    ( str-obj ) copy: list add: \ place first nemesis in q
    begin
      r next: \ check for more nemeses
    while
       ( str-obj ) copy: list add: \ place next nemesis in q
    repeat
  then ;

: probe
  begin
    s each: \ for each tuple object in s
  while
    ( obj ) join \ pass the object to function join
  repeat ;

probe \ execute the probe function

q p: \ print the saved relation

\ free allocated memory
s <free
r free2:
q free:

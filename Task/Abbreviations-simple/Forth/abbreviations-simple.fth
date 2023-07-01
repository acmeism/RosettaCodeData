include FMS-SI.f
include FMS-SILib.f

${ add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3
   compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate
   3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2
   forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load
   locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2
   msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3
   refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left
   2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1 }
   value list  ' upper: list map:

: compare' { adr len $obj -- f }
  len $obj size: > if false exit then
  adr len $obj @: drop len compare 0= ;

: <= ( n1 n2 = f) 1+ swap > ;

: abbrev 0 0 { adr len obj1 obj2 -- }
  list uneach:
  list each: drop to obj1
  begin
   list each:
  while
   to obj2
   obj2 @: >integer
     if  \ word followed by a number
         len <= if adr len obj1 compare'
                   if obj1 p: exit then
                then list each: if to obj1  else ." *error* " exit then
     else \ word not followed by a number
          adr len obj1 @: compare 0=
          if obj1 p: exit then
          obj2 to obj1
     then
  repeat ;

${ riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin }
  value input-list  ' upper: input-list map:

: valid-input ( adr len -- f)
  over + swap do i c@ isalpha 0= if ." *error* " unloop false exit then loop true ;

: run
  begin
    input-list each:
  while
    dup @: valid-input
    if @: abbrev space else drop then
  repeat ;


run RIGHT REPEAT *error*  PUT MOVE RESTORE *error*  *error* *error* POWERINPUT ok

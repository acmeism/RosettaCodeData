\ -- notes.txt
include lib/argopen.4th
include lib/ansfacil.4th

\ -- dump notes.txt
4096 buffer: buf
: dump ( -- )
  input 1 arg-open
  begin buf dup 4096 accept dup while type repeat
  drop drop close ;

\ -- time and date
: :00 <# # # [char] : hold #> type ;
: -00 <# # # [char] - hold #> type ;
: .time 0 .r :00 :00 ;
: .date 0 .r -00 -00 ;

\ -- add note
: add-note ( c-addr u -- )
  output append [+] 1 arg-open -rot
  time&date .date space .time cr
  9 emit type cr close ;

\ -- note
: note ( "note" -- )
  argn 2 < abort" Usage: notes filename"
  refill drop 0 parse dup if add-note else 2drop dump then ;

note

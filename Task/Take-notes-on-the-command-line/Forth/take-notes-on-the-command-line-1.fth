vocabulary note-words
get-current also note-words definitions

\ -- notes.txt
variable file
: open       s" notes.txt" r/w open-file if
             s" notes.txt" r/w create-file throw then file ! ;
: appending  file @ file-size throw file @ reposition-file throw ;
: write      file @ write-file throw ;
: close      file @ close-file throw ;

\ -- SwiftForth console workaround
9 constant TAB
: type ( c-addr u -- )
  bounds ?do
    i c@ dup TAB = if drop 8 spaces else emit then
  loop ;

\ -- dump notes.txt
create buf 4096 allot
: dump ( -- )
  cr begin buf 4096 file @ read-file throw dup while
    buf swap type
  repeat drop ;

\ -- time and date
: time   @time (time) ;
: date   @date (date) ;

\ -- add note
: cr     s\" \n" write ;
: tab    s\" \t" write ;
: space  s"  " write ;
: add-note ( c-addr u -- ) appending
  date write space time write cr
  tab ( note ) write cr ;

set-current

\ -- note
: note ( "note" -- )
  open 0 parse dup if add-note
  else 2drop dump then close ;
previous

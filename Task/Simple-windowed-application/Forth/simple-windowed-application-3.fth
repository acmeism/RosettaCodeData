0 value tk-in
0 value tk-out
variable #clicks
0 #clicks !

: wish{    \ send command to wish
    tk-in to outfile-id ;
: }wish    \ finish command to wish
    tk-in flush-file throw
    stdout to outfile-id ;


: add-one  1 #clicks +! ;
: update-wish   wish{ .\" .label configure -text \"clicks: " #clicks @ . .\" \"" cr }wish ;

: counting
begin
    tk-out key-file
    dup '+' = if add-one update-wish then    \ add one if '+' received
    4 = until ;                              \ until Ctrl-D, wish exit

: initiating
    s" mkfifo tk-in tk-out" system
    s" wish <tk-in >tk-out &" system
    s" tk-in" w/o open-file throw to tk-in
    s" tk-out" r/o open-file throw to tk-out
    wish{ .\" pack [ label  .label -text \"There have been no clicks yet\" ] " cr }wish
    wish{ .\" pack [ button .click -text \"Click Me\" -command { puts \"+\" } ] " cr }wish ;

: cleaning
    tk-in close-file
    tk-out close-file
    s" rm tk-in tk-out" system ;

initiating counting cleaning

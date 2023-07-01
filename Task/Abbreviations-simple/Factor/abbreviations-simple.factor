USING: arrays assocs combinators formatting fry grouping.extras
kernel literals math math.parser multiline sequences
splitting.extras unicode ;
IN: rosetta-code.abbr-simple

CONSTANT: input $[
"riG   rePEAT copies  put mo   rest    types   fup.    6       "
"poweRin" append
]

<<     ! Make the following two words available at parse time.

: abbr-pair ( first second -- seq/f )
    {
        { [ 2dup drop [ digit? ] all? ] [ 2drop f ] }
        {
            [ 2dup nip [ Letter? ] all? ]
            [ drop >upper 0 2array ]
        }
        [ [ >upper ] [ string>number ] bi* 2array ]
    } cond ;

: parse-commands ( seq -- seq )
    " \n" split-harvest [ abbr-pair ] 2clump-map sift ;

>>

CONSTANT: commands $[
HEREDOC: END
add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange
Cinsert 2  Clast 3 compress 4 copy 2 count 3 Coverlay 3 cursor 3
delete 3 Cdelete 2  down 1  duplicate 3 xEdit 1 expand 3 extract
3 find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2 forward
2  get  help 1  hexType 4  input 1 powerInput 3  join  1 split 2
spltJOIN load locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix
2  macro  merge 2  modify  3  move 2 msg  next 1 overlay 1 parse
preserve 4 purge 3 put putD query 1 quit  read recover 3 refresh
renum 3 repeat 3 replace 1 Creplace  2 reset 3 restore 4 rgtLEFT
right 2 left 2  save  set  shift 2  si  sort sos  stack 3 status
4 top  transfer 3  type 1  up 1
END
parse-commands
]

: valid-abbrevs ( assoc seq -- assoc )
    dup '[ [ _ head? ] [ _ length <= ] bi* and ] assoc-filter ;

: find-command ( seq -- seq )
    >upper [ commands ] dip valid-abbrevs
    [ "*error*" ] [ first first ] if-empty ;

: (find-commands) ( seq -- seq )
    " " split-harvest [ find-command ] map " " join ;

: find-commands ( seq -- seq )
    dup empty? not [ (find-commands) ] when ;

: show-commands ( seq -- )
    dup find-commands " Input: \"%s\"\nOutput: \"%s\"\n" printf
    ;

: main ( -- ) input "" [ show-commands ] bi@ ;

MAIN: main

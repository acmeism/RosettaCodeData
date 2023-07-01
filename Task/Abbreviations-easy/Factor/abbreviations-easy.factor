USING: arrays ascii assocs combinators.short-circuit io kernel
literals math qw sequences sequences.extras splitting.extras ;
IN: rosetta-code.abbreviations-easy

CONSTANT: commands qw{
Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst
COMPress COpy COUnt COVerlay CURsor DELete CDelete Down
DUPlicate Xedit EXPand EXTract Find NFind NFINDUp NFUp CFind
FINdup FUp FOrward GET Help HEXType Input POWerinput Join SPlit
SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix
MACRO MErge MODify MOve MSG Next Overlay PARSE PREServe PURge
PUT PUTD  Query  QUIT READ  RECover REFRESH RENum REPeat
Replace CReplace  RESet  RESTore  RGTLEFT RIght LEft  SAVE  SET
SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up }

CONSTANT: user-input $[ "riG   rePEAT copies  put mo   rest    "
"types   fup.    6       poweRin" append ]

: starts-with? ( cand com -- ? ) [ >upper ] bi@ start 0 = ;
: capitals ( str -- n ) [ LETTER? ] count ;
: min-len? ( candidate command -- ? ) capitals swap length <= ;
: not-longer? ( candidate command -- ? ) [ length ] bi@ <= ;
: permitted? ( candidate command -- ? ) dup [ letter? ] count 0
    > [ [ >upper ] bi@ = ] dip or ;

: valid-abbr? ( candidate command -- ? )
    {
        [ permitted?   ]
        [ starts-with? ]
        [ min-len?     ]
        [ not-longer?  ]
    } 2&& ;

: find-command ( candidate -- command/f )
    commands swap [ swap valid-abbr? ] curry find nip ;

: process-candidate ( candidate -- abbr/error )
    find-command [ >upper ] [ "*error*" ] if* ;

: process-user-string ( str -- seq ) dup "" = [ drop "" ]
    [ " " split-harvest [ process-candidate ] map ] if ;

: .abbr ( input -- )
    [ " " split-harvest ] [ process-user-string ] bi zip
    [ first2 32 pad-longest 2array ] map
    [ keys ] [ values ] bi
    [ " " join ] bi@
    [ "User words: " write print ]
    [ "Full words: " write print ] bi* ;

: main ( -- ) user-input "" [ .abbr ] bi@ ;

MAIN: main

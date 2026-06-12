11    constant      WordLen
128   constant      max-line

create              SearchSub  80 allot
Create              SrcFile   256 allot
Variable            fhin
variable            Cnt

: SrcOpen           Srcfile count r/o open-file throw Fhin ! ;
: SrcClose          fhin @ close-file throw ;
: third             >r over r> swap ;
: cnt++             cnt 1 swap   +! ;
: SubStrFound       SearchSub count  Search ;

: read-lines        fhin @
                    begin  pad max-line third read-line throw
                    while  pad swap dup WordLen >
                           if   2dup  SubStrFound -rot  2drop
                                if cnt++ cr  type else 2drop then
                           else 2DROP
                           then
                    repeat 2drop  ;

: Test              0 cnt !
                    s" ./unixdict.txt"  SrcFile   place
                    s" the"             SearchSub place
                    SrcOpen
                    read-lines
                    cr ." =============="
                    cr ." Found " cnt @  . ." Words" cr
                    SrcClose ;

Test

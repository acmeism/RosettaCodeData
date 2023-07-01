1024      constant  max-Line
char >    constant  marker

: read-lines        begin  pad max-line >r over r> swap
                           read-line throw
                    while  pad dup c@ marker =
                           if cr 1+ swap type ."  : "
                           else swap  type
                           then
                    repeat drop  ;

: Test              s" ./FASTA.txt" r/o open-file throw
                    read-lines
                    close-file throw
                    cr ;
Test

: INPUT$ ( text -- n n )
  pad swap accept pad swap ;
cr ." Enter file name : " 20 INPUT$ w/o create-file throw Value fd-out
: get-content cr ." Enter your nickname : " 20 INPUT$ fd-out write-file cr ;
: close-output ( -- )  fd-out close-file throw ;
get-content
\ Inject a carriage return at end of file
s\" \n" fd-out write-file
close-output
bye

: >string ( d -- addr n )
  dup >r dabs <# #s r> sign #> ;

: inc-string ( addr -- )
  dup count number? not abort" invalid number"
  1 s>d d+ >string rot place ;

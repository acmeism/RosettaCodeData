256 buffer: filename-buf
: each-filename { xt -- }  \ xt-consuming variant
  s" ." open-dir throw { d }
  begin filename-buf 256 d read-dir throw while
    filename-buf swap xt execute
  repeat  d close-dir throw ;

\ immediate variant
: each-filename[  s" ." postpone sliteral ]] open-dir throw >r begin filename-buf 256 r@ read-dir throw while filename-buf swap [[ ; immediate compile-only
: ]each-filename  ]] repeat drop r> close-dir throw [[ ; immediate compile-only

: ls ( -- )  [: cr type ;] each-filename ;

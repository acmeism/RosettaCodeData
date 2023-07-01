variable	   'src
variable	   #src
variable     offset

: advance    1 offset +! ;
: chr@       offset @ 'src @ + c@ ;
: nextchr    advance chr@ ;
: bound      offset @ #src @ u< ;
: separator? dup [char] | = if drop cr             else  emit      then ;
: escape?    dup [char] ^ = if drop  nextchr  emit else separator? then ;
: tokenize   0 offset ! begin bound while nextchr escape? repeat ;

\ Test of  function
Here 'src ! ," one^|uno||three^^^^|four^^^|^cuatro|" here  'src @ - #src  !
page
cr ." #### start ####" cr tokenize cr ." #### End  ####" cr

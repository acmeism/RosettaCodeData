variable	     'src
variable	     #src
variable       'out
variable       #out

: Replace~     dup [char] ~  =                   \ test for  escape char
               if   'out @ 1+  #out @ type  drop \ replace the escape char
               else emit                         \ otherwise write  char
               then  ;
: format       0
               begin  dup  #src @ u<
               while  1+ dup 'src @ + c@
                      replace~
               repeat ;

\ Test of  function
Here 'src ! ," Mary had a ~ lamb" here  'src @ - #src  !
page
cr ." Original        : "
'src @ 1+ #src @ type
cr ." 1st Replacement : "
  here 'out ! ," little" here 'out @ - #out !
  format
cr ." 2nd Replacement : "
  here 'out  ! ," BIG" here 'out @ - #out !
  format

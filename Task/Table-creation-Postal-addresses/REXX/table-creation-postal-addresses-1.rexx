/*REXX program creates, builds, and displays a table of given  U.S.A.  postal addresses.*/
@usa.=;   @usa.0=0;      $='@USA.'                   /*initialize array and first value.*/
@usa.0=@usa.0 + 1                                    /*bump the unique number for usage.*/
                  call USA '_city'  ,  'Boston'
                  call USA '_state' ,  'MA'
                  call USA '_addr1' ,  "51 Franklin Street"
                  call USA '_name'  ,  "FSF Inc."
                  call USA '_zip'   ,  '02110-1301'
@usa.0=@usa.0 + 1                                    /*bump the unique number for usage.*/
                  call USA '_city'  ,  'Washington'
                  call USA '_state' ,  'DC'
                  call USA '_addr1' ,  "The Oval Office"
                  call USA '_addr2' ,  "1600 Pennsylvania Avenue NW"
                  call USA '_name'  ,  "The White House"
                  call USA '_zip'   ,  20500         /*no need for quotes for a number. */
                  call USA 'list'
exit                                            /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
tell: parse arg a; z=value($||#"."a); if z\='' then say right(translate(a,,'_'),9) "──►" z
      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
USA: procedure expose @usa. $;  parse arg what;  arg ?
     if ?=='LIST'  then do #=1  for @usa.0
                        call tell '_name'
                                             do j=1  until z='';  call tell "_addr"j;  end
                        call tell '_city'
                        call tell '_state'
                        call tell '_zip'
                        say copies('─', 45)
                        end  /*#*/
                   else do;      call value $ || @usa.0'.'what   , arg(2)
                                 call value $ || @usa.0'.upHist' , userid() date() time()
                        end
     return

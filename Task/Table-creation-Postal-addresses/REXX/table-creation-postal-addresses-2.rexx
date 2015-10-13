/*REXX program creates, builds, and lists a table of  U.S.A. postal addresses.*/
@usa.=;  @usa.0=0                      /*initialize stemmed array & 1st value.*/
@usa.0=@usa.0+1                        /*bump the unique number for usage.    */
       call USA '_city'  ,  'Boston'
       call USA '_state' ,  'MA'
       call USA '_addr'  ,  "51 Franklin Street"
       call USA '_name'  ,  "FSF Inc."
       call USA '_zip'   ,  '02110-1301'
@usa.0=@usa.0+1                        /*bump the unique number for usage.    */
       call USA '_city'  ,  'Washington'
       call USA '_state' ,  'DC'
       call USA '_addr'  ,  "The Oval Office"
       call USA '_addr2' ,  "1600 Pennsylvania Avenue NW"
       call USA '_name'  ,  "The White House"
       call USA '_zip'   ,  20500
       call USA 'list'
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
USA: procedure expose @USA.;  parse arg what,txt;            arg ?;   nn=@usa.0
if ?=='LIST'   then do nn=1  for @usa.0;  call lister;  end  /*nn*/
               else do
                    call value '@USA.'nn"."what  , txt
                    call value '@USA.'nn".upHist", userid()  date()   time()
                    end
return
/*────────────────────────────────────────────────────────────────────────────*/
tell:      _=value('@USA.'nn"."arg(1))
        if _\==''  then say  right(translate(arg(1), , '_'),  6)   "──►"   _
        return
/*────────────────────────────────────────────────────────────────────────────*/
lister: call tell '_name'
        call tell '_addr'
                           do j=2  until _=='';  call tell '_addr'j;  end  /*j*/
        call tell '_city'
        call tell '_state'
        call tell '_zip'
        say copies('─', 40)
        return

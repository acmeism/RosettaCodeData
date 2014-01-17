/*REXX program to create/build/list a table of US postal addresses.     */
/*┌────────────────────────────────────────────────────────────────────┐
  │ Format of an entry in the USA address/city/state/zipcode structure.│
  │                                                                    │
  │ The "structure" name can be any legal variable name, but here the  │
  │ name will be shortened to make these comments (and program) easier │
  │ to read; its name will be    @USA     (in any case).  In addition, │
  │ the following variables names (stemmed array tails) will need to   │
  │ be kept uninitialized  (that is, not used for any variable name).  │
  │ To that end, each of these "hands-off" variable names will have an │
  │ underscore in the beginning of each name.  Other possibilities are │
  │ to have a trailing underscore (or both leading and trailing), some │
  │ other special eye-catching character such as:  ! @ # $ ?           │
  │                                                                    │
  │ Any field not specified will have a value of "null"  (length 0).   │
  │                                                                    │
  │ Any field can contain any number of characters, this can be limited│
  │ by the restrictions imposed by standards or USA legal definitions. │
  │ Any number of fields could be added (with invalid field testing).  │
  ├────────────────────────────────────────────────────────────────────┤
  │  @USA.0             the number of entries in the @USA "array".     │
  │                                                                    │
  │       nnn           is some positive integer (no leading zeros, it │
  │                       can be any length).                          │
  ├────────────────────────────────────────────────────────────────────┤
  │  @USA.nnn._name     = name of person, business, or lot description.│
  ├────────────────────────────────────────────────────────────────────┤
  │  @USA.nnn._addr     = 1st street address                           │
  │  @USA.nnn._addr2    = 2nd street address                           │
  │  @USA.nnn._addr3    = 3rd street address                           │
  │  @USA.nnn._addrNN   =  ...  (any number, but in sequential order). │
  ├────────────────────────────────────────────────────────────────────┤
  │  @USA.nnn._state    = US postal code for the state/territory/etc.  │
  ├────────────────────────────────────────────────────────────────────┤
  │  @USA.nnn._city     = official city name, may include any char.    │
  ├────────────────────────────────────────────────────────────────────┤
  │  @USA.nnn._zip      = US postal zipcode,  5 digit format or        │
  │                                              10 char format.       │
  ├────────────────────────────────────────────────────────────────────┤
  │  @USA.nnn._upHist   = update History (who, date and timestamp).    │
  └────────────────────────────────────────────────────────────────────┘*/
@USA.=;  @USA.0=0

@usa.0=@usa.0+1                        /*bump the unique number for use.*/
call @USA '_city','Boston'
call @USA '_state','MA'
call @USA '_addr',"51 Franklin Street"
call @USA '_name',"FSF Inc."
call @USA '_zip','02110-1301'

@usa.0=@usa.0+1                        /*bump the unique number for use.*/
call @USA '_city','Washington'
call @USA '_state','DC'
call @USA '_addr',"The Oval Office"
call @USA '_addr2',"1600 Pennsylvania Avenue NW"
call @USA '_name',"The White House"
call @USA '_zip',20500
call @USA 'list'
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────@USA subroutine────────────────────────*/
@USA: procedure expose @USA.; parse arg what,txt; arg ?; nn=@usa.0
if ?\=='LIST' then do
                   call value '@USA.'nn"."what,txt
                   call value '@USA.'nn".upHist",userid() date() time()
                   end
              else do nn=1  for @usa.0
                   call @USA_list
                   end   /*nn*/
return
/*───────────────────────────────@USA_tell subroutine───────────────────*/
@USA_tell: _=value('@USA.'nn"."arg(1));
           if _\==''  then say right(translate(arg(1),,'_'),6) "──►" _
           return
/*───────────────────────────────@USA_list subroutine───────────────────*/
@USA_list: call @USA_tell '_name'
           call @USA_tell '_addr'
                                           do j=2  until _==''
                                           call @USA_tell '_addr'j
                                           end   /*j*/
           call @USA_tell '_city'
           call @USA_tell '_state'
           call @USA_tell '_zip'
           say copies('─',40)
           return

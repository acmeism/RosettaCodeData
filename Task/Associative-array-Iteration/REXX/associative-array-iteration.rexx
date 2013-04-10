/*REXX program shows how to set/display values for an associative array.*/
/*┌────────────────────────────────────────────────────────────────────┐
  │ The (below) two REXX statements aren't really necessary, but it    │
  │ shows how to define any and all entries in a associative array so  │
  │ that if a "key" is used that isn't defined, it can be displayed to │
  │ indicate such, or its value can be checked to determine if it has  │
  │ been set.                                                          │
  └────────────────────────────────────────────────────────────────────┘*/
stateF.=' [not defined yet] '          /*sets any/all state former caps.*/
stateN.=' [not defined yet] '          /*sets any/all state names.      */
/*┌────────────────────────────────────────────────────────────────────┐
  │ In REXX, when a "key" is used, it's normally stored (internally)   │
  │ as uppercase characters (as in the examples below).  Actually, any │
  │ characters can be used,  including blank(s) and non-displayable    │
  │ characters  (including '00'x, 'ff'x, commas, periods, quotes, ...).│
  └────────────────────────────────────────────────────────────────────┘*/
stateL=''                              /*list of states (empty now).    */
                                       /*nice to be in alphabetic order,*/
                                       /*they'll be listed in this order*/
                                       /*With a little more code, they  */
                                       /*  could be sorted quite easily.*/

call setSC 'al', "Alabama"            ,'Tuscaloosa'
call setSC 'ca', "California"         ,'Benicia'
call setSC 'co', "Colorado"           ,'Denver City'
call setSC 'ct', "Connecticut"        ,'Hartford and New Haven (joint)'
call setSC 'de', "Delaware"           ,'New-Castle'
call setSC 'ga', "Georgia"            ,'Milledgeville'
call setSC 'il', "Illinois"           ,'Vandalia'
call setSC 'in', "Indiana"            ,'Corydon'
call setSC 'ia', "Iowa"               ,'Iowa City'
call setSC 'la', "Louisiana"          ,'New Orleans'
call setSC 'me', "Maine"              ,'Portland'
call setSC 'mi', "Michigan"           ,'Detroit'
call setSC 'ms', "Mississippi"        ,'Natchez'
call setSC 'mo', "Missoura"           ,'Saint Charles'
call setSC 'mt', "Montana"            ,'Virginia City'
call setSC 'ne', "Nebraska"           ,'Lancaster'
call setSC 'nh', "New Hampshire"      ,'Exeter'
call setSC 'ny', "New York"           ,'New York'
call setSC 'nc', "North Carolina"     ,'Fayetteville'
call setSC 'oh', "Ohio"               ,'Chillicothe'
call setSC 'ok', "Oklahoma"           ,'Guthrie'
call setSC 'pa', "Pennsylvania"       ,'Lancaster'
call setSC 'sc', "South Carolina"     ,'Charlestown'
call setSC 'tn', "Tennessee"          ,'Murfreesboro'
call setSC 'vt', "Vermont"            ,'Windsor'

       do j=1 for words(stateL)        /*list all capitals that were set*/
       q=word(stateL,j)
       say 'the former capital of ('q")" stateN.q "was" stateC.q
       end    /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────setSC subroutine─────────────────*/
setSC: arg code; parse arg ,name,cap   /*get upper code, get name & cap.*/
stateL=stateL code                     /*keep a list of all state codes.*/
stateN.code=name                       /*set the state's name.          */
stateC.code=cap                        /*set the state's capital.       */
return

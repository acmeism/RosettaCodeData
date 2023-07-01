/*REXX program demonstrates how to  set and display  values  for an  associative array. */
/*╔════════════════════════════════════════════════════════════════════════════════════╗
  ║ The (below) two REXX statements aren't really necessary,  but it shows how to      ║
  ║ define any and all entries in a associative array so that if a "key" is used that  ║
  ║ isn't defined, it can be displayed to indicate such,  or its value can be checked  ║
  ║ to determine if a particular associative array element has been set (defined).     ║
  ╚════════════════════════════════════════════════════════════════════════════════════╝*/
stateF.= ' [not defined yet] '                   /*sets any/all state  former  capitals.*/
stateN.= ' [not defined yet] '                   /*sets any/all state names.            */
w      = 0                                       /*the maximum  length  of a state name.*/
stateL =
/*╔════════════════════════════════════════════════════════════════════════════════════╗
  ║ The list of states (empty as of now).  It's convenient to have them in alphabetic  ║
  ║ order;  they'll be listed in the order as they are in the REXX program below).     ║
  ║ In REXX,  when a key is used  (for a stemmed array,  as they are called in REXX),  ║
  ║ and the key isn't assigned a value,  the key's  name  is stored (internally)  as   ║
  ║ uppercase  (Latin)  characters  (as in the examples below.   If the  key  has a    ║
  ║ a value, the key's value is used as is  (i.e.:  no upper translation is performed).║
  ║ Actually,  any characters can be used,  including blank(s)  and  non─displayable   ║
  ║ characters  (including   '00'x,   'ff'x,   commas,   periods,   quotes,   ···).    ║
  ╚════════════════════════════════════════════════════════════════════════════════════╝*/
call setSC 'al',  "Alabama"            ,  'Tuscaloosa'
call setSC 'ca',  "California"         ,  'Benicia'
call setSC 'co',  "Colorado"           ,  'Denver City'
call setSC 'ct',  "Connecticut"        ,  'Hartford and New Haven  (jointly)'
call setSC 'de',  "Delaware"           ,  'New-Castle'
call setSC 'ga',  "Georgia"            ,  'Milledgeville'
call setSC 'il',  "Illinois"           ,  'Vandalia'
call setSC 'in',  "Indiana"            ,  'Corydon'
call setSC 'ia',  "Iowa"               ,  'Iowa City'
call setSC 'la',  "Louisiana"          ,  'New Orleans'
call setSC 'me',  "Maine"              ,  'Portland'
call setSC 'mi',  "Michigan"           ,  'Detroit'
call setSC 'ms',  "Mississippi"        ,  'Natchez'
call setSC 'mo',  "Missouri"           ,  'Saint Charles'
call setSC 'mt',  "Montana"            ,  'Virginia City'
call setSC 'ne',  "Nebraska"           ,  'Lancaster'
call setSC 'nh',  "New Hampshire"      ,  'Exeter'
call setSC 'ny',  "New York"           ,  'New York'
call setSC 'nc',  "North Carolina"     ,  'Fayetteville'
call setSC 'oh',  "Ohio"               ,  'Chillicothe'
call setSC 'ok',  "Oklahoma"           ,  'Guthrie'
call setSC 'pa',  "Pennsylvania"       ,  'Lancaster'
call setSC 'sc',  "South Carolina"     ,  'Charlestown'
call setSC 'tn',  "Tennessee"          ,  'Murfreesboro'
call setSC 'vt',  "Vermont"            ,  'Windsor'

       do j=1  for words(stateL)                 /*show all capitals that were defined. */
       $= word(stateL, j)                        /*get the next (USA) state in the list.*/
       say 'the former capital of  ('$") "    left(stateN.$, w)      " was "      stateC.$
       end    /*j*/                              /* [↑]   show states that were defined.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
setSC: parse arg code,name,cap;   upper code     /*get code, name & cap.; uppercase code*/
       stateL= stateL code                       /*keep a list of all the US state codes*/
       stateN.code= name; w= max(w,length(name)) /*define the state's name;  max width. */
       stateC.code= cap                          /*   "    "     "   code to the capital*/
       return                                    /*return to invoker, SETSC is finished.*/

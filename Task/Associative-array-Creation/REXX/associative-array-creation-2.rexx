/*REXX program shows how to set/display values for an associative array.*/
/*┌────────────────────────────────────────────────────────────────────┐
  │ The (below) two REXX statements aren't really necessary, but it    │
  │ shows how to define any and all entries in a associative array so  │
  │ that if a "key" is used that isn't defined, it can be displayed to │
  │ indicate such, or its value can be checked to determine if a       │
  │ particular associative array element has been set (defined).       │
  └────────────────────────────────────────────────────────────────────┘*/
stateC.=' [not defined yet] '          /*sets any/all state capitols.   */
stateN.=' [not defined yet] '          /*sets any/all state names.      */
/*┌────────────────────────────────────────────────────────────────────┐
  │ In REXX, when a "key" is used, it's normally stored (internally)   │
  │ as uppercase characters (as in the examples below).  Actually, any │
  │ characters can be used,  including blank(s) and non-displayable    │
  │ characters  (including '00'x, 'ff'x, commas, periods, quotes, ...).│
  └────────────────────────────────────────────────────────────────────┘*/
stateC.ca='Sacramento'; stateN.ca='California'
stateC.nd='Bismarck'  ; stateN.nd='North Dakota'
stateC.mn='St. Paul'  ; stateN.mn='Minnesota'
stateC.dc='Washington'; stateN.dc='District of Columbia'
stateC.ri='Providence'; stateN.ri='Rhode Island and Providence Plantations

say 'capital of California is' stateC.ca
say 'capital of Oklahoma is' stateC.ok
yyy='RI'
say 'capital of' stateN.yyy "is" stateC.yyy
                                       /*stick a fork in it, we're done.*/

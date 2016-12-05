   0 105 A."_1 matchMake ''  NB. swap abi and bea
┌───┬────┬───┬───┬───┬────┬───┬───┬────┬───┐
│abe│bob │col│dan│ed │fred│gav│hal│ian │jon│
├───┼────┼───┼───┼───┼────┼───┼───┼────┼───┤
│ivy│cath│dee│fay│jan│abi │gay│eve│hope│bea│
└───┴────┴───┴───┴───┴────┴───┴───┴────┴───┘
   checkStable 0 105 A."_1 matchMake ''
Engagements preferred by both members to their current ones:
┌────┬───┐
│fred│bea│
├────┼───┤
│jon │fay│
├────┼───┤
│jon │gay│
├────┼───┤
│jon │eve│
└────┴───┘
|assertion failure: assert
|       assert-.bad

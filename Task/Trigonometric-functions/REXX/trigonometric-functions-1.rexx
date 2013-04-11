 ┌──────────────────────────────────────────────────────────────────────────┐
 │  One common method that ensures enough accuracy in REXX is specifying    │
 │  more precision  (via  NUMERIC DIGITS  nnn)  than is needed,  and then   │
 │  displaying the number of digits that are desired,  or  the number(s)    │
 │  could be re-normalized using the  FORMAT  bif.                          │
 │                                                                          │
 │  The technique used (below) is to set the   numeric digits   ten higher  │
 │  than the desired digits,  as specified by the   SHOWDIGS  variable.     │
 └──────────────────────────────────────────────────────────────────────────┘

/*┌────────────────────────────────────────────────────────────────────┐
┌─┘                               √                                    └─┐
│ While the above REXX code seems like it's doing a lot of extra work,   │
│ it saves a substantial amount of processing time when the precision    │
│ (DIGITs)  is a lot greater than the default  (which is nine digits).   │
│                                                                        │
│ Indeed, when computing square roots in the hundreds  (even thousands)  │
│ of digits,  this technique reduces the amount of CPU processing time   │
│ by keeping the length of the computations to a minimum (due to a large │
│ precision),  while the accuracy at the beginning isn't important for   │
│ calculating the (first) guesstimate  (the running square root guess).  │
└─┐                               √                                    ┌─┘
  └────────────────────────────────────────────────────────────────────┘*/

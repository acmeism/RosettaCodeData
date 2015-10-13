  ╔════════════════════════════════════════════════════════════════════╗
╔═╝                                __                                  ╚═╗
║                                 √                                      ║
║                                                                        ║
║ While the above REXX code seems like it's doing a lot of extra work,   ║
║ it saves a substantial amount of processing time when the precision    ║
║ (DIGITs)  is a lot greater than the default  (default is nine digits). ║
║                                                                        ║
║ Indeed, when computing square roots in the hundreds  (even thousands)  ║
║ of digits,  this technique reduces the amount of CPU processing time   ║
║ by keeping the length of the computations to a minimum (due to a large ║
║ precision),  while the accuracy at the beginning isn't important for   ║
║ calculating the (first) guesstimate  (the running square root guess).  ║
║                                                                        ║
║ Each iteration of   K   (approximately) doubles the number of digits,  ║
║ but takes almost four times longer to compute  (actually, around 3.8). ║
║                                                                        ║
║ The REXX code could be streamlined (pruned)  by removing  the          ║
║ The    NUMERIC FUZZ 0      statement can be removed  if  it is known   ║
║ that  it is already set to zero.  (which is the default).              ║
║                                                                        ║
║ Also, the   NUMERIC FORM   statement can be removed  if  it is known   ║
║ that the   form  is  SCIENTIFIC   (which is the default).              ║
║                                  __                                    ║
╚═╗                               √                                    ╔═╝
  ╚════════════════════════════════════════════════════════════════════╝

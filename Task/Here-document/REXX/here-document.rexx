/*REXX program demonstrates a method to use  "here"  documents in REXX. */
parse arg doc .                        /*"here" name is case sensitive. */

     do j=1  for sourceline()
     if sourceline(j)\=='◄◄'doc  then iterate
           do !=j+1  to sourceline()  while sourceline(!)\=='◄◄.'
           say sourceline(!)
           end   /*!*/
     exit                              /*stick a fork in it, we're done.*/
     end         /*j*/

say doc '"here" document not found.'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────start of "here" docs──────────────────
◄◄rs-232
RS─232 Signals and Pinouts  ┌─────────────────────────────────────────────────┐
                            │13  12  11  10  9   8   7   6   5   4   3   2   1│
──►  Interface between data └┐ 25  24  23  22  21  20  19  18  17  16  15  14┌┘
terminal equipment (DTE/male)└───────────────────────────────────────────────┘
and data communication equipment
[DCE/female]  employing  serial   ┌───────────────────────────────────────────┐
binary  data  interchange.        │ 12◄─secondary carrier detect   [SCD]  DCE │
┌─────────────────────────────────┤ 13◄─secondary clear to send    [SCS]  DCE │
│ 1◄─protective ground  [PG, GND] │ 14◄─secondary transmitted data [STD]  DTE │
│ 2◄─transmitted data   [TD]  DTE │ 15◄─transmit clock             [TC]   DCE │
│ 3◄─received data      [RD]  DCE │ 16◄─secondary received data    [SRD]  DCE │
│ 4◄─request to send    [RTS] DTE │ 17◄─receiver clock             [RC]   DCE │
│ 5◄─clear to send      [CTS] DCE │ 18◄─unassigned                            │
│ 6◄─data set ready     [DSR] DCE │ 19◄─secondary request to send  [SRS]  DTE │
│ 7◄─signal ground      [SG]      │ 20◄─data terminal ready        [DTR]  DTE │
│      (common return)            │ 21◄─signal quality detector    [SQD]  DCE │
│ 8◄─carrier detect     [CD]  DCE │ 22◄─ring indicator             [RI]   DCE │
│ 9◄─positive voltage   [-]       │ 23◄─data rate select       [DRS]  DCE/DTE │
│10◄─negative voltate   [-]       │ 24◄─external clock             [XTC]  DTE │
│11◄─unassigned                   │ 25◄─unassigned                            │
└─────────────────────────────────┴───────────────────────────────────────────┘
◄◄.
◄◄can
        ┌──────┐
        │      │
        │      ├┐
        │      ├┘
        │      │
        │      │
        │      │
        │      │
        │      │                                         ┌─────┐
        └──┬┬──┘                                         │┌───┐│
           ││                                            ├┤   ├┤
           ││    ┌───────────────┐                       ││   ││
           ││   ┌┴──────────────┬┘                       └┤   ├┘
           │└───┤               │                         └───┘
           └────┤            ┌──┘
                │            │
                └──┐         │
                   │         │
                   │         │
                   │         │
                   └─────────┘
◄◄.
────────────────────────────────────end of "here" docs──────────────────*/

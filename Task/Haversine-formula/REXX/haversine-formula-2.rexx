  ┌───────────────────────────────────────────────────────────────────────┐
  │ A note on built-in functions.  REXX doesn't have a lot of mathmatical │
  │ or  (particularly) trigomentric  functions,  so REXX programmers have │
  │ to write their own.  Usually, this is done once, or most likely,  one │
  │ is borrowed from another program.  Knowing this, the one that is used │
  │ has a lot of boilerplate in it.  Once coded and throughly debugged, I │
  │ put those commonly-used subroutines into the  "1-line sub"  section.  │
  │                                                                       │
  │ Programming note:  the  "general 1-line"  subroutines are taken from  │
  │ other programs that I wrote, but I broke up their one line of source  │
  │ so it can be viewed without shifting the viewing window.              │
  │                                                                       │
  │ The  "er 81"  [which won't happen here]  just shows an error telling  │
  │ the legal range for  ARCxxx  functions   (in this case:  -1 ──► +1).  │
  │                                                                       │
  │ Similarly,  the   SQRT   function checks for a negative argument      │
  │ [which again, won't happen here].                                     │
  │                                                                       │
  │ The pi constant (as used here) is actually a much more robust function│
  │ and will return up to one million digits in the real version.         │
  │                                                                       │
  │ One bad side effect is that, like a automobile without a hood, you see│
  │ all the dirty stuff going on.    Also, don't visit a sausage factory. │
  └───────────────────────────────────────────────────────────────────────┘

MCSKIP - WITH - NL
-- The line above defines the comment syntax: -- through to newline is completely deleted.
-- 99 Bottles of beer in 99 lines of ML/I by Parzival Herzog.
-- ML/I is P.J. Brown's famous general purpose macro processor designed in 1967.
--
-- Define nestable quotes {...}, replaced by the unevaluated text within:
MCSKIP MT, {}
-- Define non-nestable quotes "...", replaced by the unevaluated text within:
MCSKIP T, ""
-- Define the argument insertion and expression evaluation syntax:
-- ?e. is replaced by the value of macro expression e:
MCINS ?.
--
-- Top level macro: Sing N CONTAINERS of CONTENTS SOMEWHERE : DO THE DEED! REPLENISH.
MCDEF "Sing WITH SPACE  SPACE  of WITH SPACE  SPACE  :  !  ." AS --
{MCDEF "CONTAINERS" AS "{"?A2."}"
MCDEF "CONTAINER" AS "{"MCSUB(CONTAINERS,1,-1)"}"
MCDEF "CONTENTS" AS "{"?A3."}"
MCDEF "SOMEWHERE" AS "{"?A4."}"
MCDEF "DO WITHS THE WITHS DEED" AS "{"?A5."}"
MCDEF "REPLENISH" AS "{"?A6."}"
MCSET T1 = ?A1.
MCDEF "n" AS "("?T1.")"
MCDEF "N" AS "{"n"}"
?L1.n of CONTENTS SOMEWHERE,
    n of CONTENTS.
MCGO L2 UNLESS ?T1. GR 0
MCSET T1 = T1 - 1
MCDEF "n" AS "("?T1.")"
DO THE DEED:
    n of CONTENTS SOMEWHERE.

MCGO L1
?L2.REPLENISH:
    N of CONTENTS SOMEWHERE!}
--
-- (n): Wordify 0 to 99 CONTAINERS
MCDEF "()" AS {MCSET T1=?A1.
MCGO L1 UNLESS T1 GR 99
?T1. CONTAINERS-- Return the decimal number instead of words.
MCGO L0
?L1.MCGO L2 IF T1 GR 9
MCDEF "0units" AS ?T1."Unit"
MCGO L3
?L2.MCSET T3 = T1 - T1/10*10
MCDEF "0units" AS ?T3."unit"
MCSET T1 = T1 / 10
MCDEF "0tens" AS ?T1."Ten"
0tens?L3.0units CONTAINERS}
-- Exceptions:
MCDEF "(WITH 0 WITH)" AS {"No more" CONTAINERS}
MCDEF "(WITH 1 WITH)" AS {"One more" CONTAINER}
MCDEF "(WITH 11 WITH)" AS {"Eleven" CONTAINERS}
MCDEF "(WITH 12 WITH)" AS {"Twelve" CONTAINERS}
MCDEF "(WITH 13 WITH)" AS {"Thirteen" CONTAINERS}
MCDEF "(WITH 14 WITH)" AS {"Fourteen" CONTAINERS}
MCDEF "(WITH 15 WITH)" AS {"Fifteen" CONTAINERS}
MCDEF "(WITH 16 WITH)" AS {"Sixteen" CONTAINERS}
MCDEF "(WITH 17 WITH)" AS {"Seventeen" CONTAINERS}
MCDEF "(WITH 18 WITH)" AS {"Eighteen" CONTAINERS}
MCDEF "(WITH 19 WITH)" AS {"Nineteen" CONTAINERS}
-- Regular cases:
MCDEF "2Unit" AS {"Two"}
MCDEF "3Unit" AS {"Three"}
MCDEF "4Unit" AS {"Four"}
MCDEF "5Unit" AS {"Five"}
MCDEF "6Unit" AS {"Six"}
MCDEF "7Unit" AS {"Seven"}
MCDEF "8Unit" AS {"Eight"}
MCDEF "9Unit" AS {"Nine"}
MCDEF "0unit" AS
MCDEF "1unit" AS {" one"}
MCDEF "2unit" AS {" two"}
MCDEF "3unit" AS {" three"}
MCDEF "4unit" AS {" four"}
MCDEF "5unit" AS {" five"}
MCDEF "6unit" AS {" six"}
MCDEF "7unit" AS {" seven"}
MCDEF "8unit" AS {" eight"}
MCDEF "9unit" AS {" nine"}
MCDEF "1Ten" AS {"Ten"}
MCDEF "2Ten" AS {"Twenty"}
MCDEF "3Ten" AS {"Thirty"}
MCDEF "4Ten" AS {"Forty"}
MCDEF "5Ten" AS {"Fifty"}
MCDEF "6Ten" AS {"Sixty"}
MCDEF "7Ten" AS {"Seventy"}
MCDEF "8Ten" AS {"Eighty"}
MCDEF "9Ten" AS {"Ninety"}
--
-- The specified song:
Sing 99 bottles of beer on the wall: Take one down, pass it around! --
Go to the store and buy some more.
--
--
-- Try uncommenting the next two lines:
-- Sing 7 flasks of Armagnac on the table: Take a swig, throw it down!
-- Emilie vists, she brings some more.

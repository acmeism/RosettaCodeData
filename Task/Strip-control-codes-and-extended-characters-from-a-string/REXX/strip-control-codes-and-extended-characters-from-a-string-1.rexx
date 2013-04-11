/*REXX program to strip all "control codes" from a string (ASCII|EBCDIC)*/
xxx='string of ☺☻♥♦⌂, may include control characters and other ilk.♫☼§►↔◄'
                                       /*in EBCDIC, digit  1  is  'f1'x,*/
                                       /*in  ASCII, digit  1  is  '31'x.*/
ebcdic=   1=='f1'x                     /*is this an   EBCDIC   computer?*/
                                       /*generate a string of chars from*/
                                       /*'00'x ──► [1 just before blank]*/
ccChars = xrange(,d2c(c2d(' ') -1))    /*generate a range of characters.*/
if \ebcdic  then ccChars=ccChars'7f'x  /*add the ASCII  '7f'X  char.    */
say 'hex ccChars =' c2x(ccChars)       /*might as well do a show & tell.*/
ccCharsX = ccChars'ff'x                /*add a "stop" char for ccCharsX.*/
/*══════════════════════════════════════════════════════════════════════*/
_stop = substr(ccCharsX, verify(ccCharsX, xxx), 1)   /*find a stop char.*/
yyy = translate(space(translate(xxx, _stop, " "ccChars), 0), , _stop)
/*══════════════════════════════════════════════════════════════════════*/
say 'old = >>>'xxx"<<<"                /*add fence before&after old text*/
say 'new = >>>'yyy"<<<"                /* "    "      "    "    new text*/
                                       /*stick a fork in it, we're done.*/

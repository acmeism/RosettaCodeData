/*REXX program to strip all "control codes" from a string (ASCII|EBCDIC)*/
xxx='string of ☺☻♥♦⌂, may include control characters and other ilk.♫☼§►↔◄'
                                       /*in EBCDIC, digit  1  is  'f1'x,*/
                                       /*in  ASCII, digit  1  is  '31'x.*/
ascii=   '31'x==1                      /*is this an   ASCII   computer? */
                                       /*   (if you are ASCII-centric.) */
                                       /*generate a string of chars from*/
                                       /*'00'x --> [1 just before blank]*/
ccChars=xrange(, d2c(c2d(' ') -1))     /*generate a range of characters.*/
if ascii  then ccChars = ccChars'7f'x  /*add the ASCII  '7f'X  char.    */
say 'hex ccChars =' c2x(ccChars)       /*might as well do a show & tell.*/
/*══════════════════════════════════════════════════════════════════════*/
yyy=''                                 /*start with a clean slate.      */
  do j=1  for length(xxx)              /*build new str, 1 byte at a time*/
  _ = substr(xxx,j,1)                  /*get next char in the old string*/
  if pos(_,ccChars)\==0  then iterate  /*skip this char,  it's a no-no. */
  yyy = yyy || _                       /*we found a good & decent fellow*/
  end
/*══════════════════════════════════════════════════════════════════════*/
say 'old = >>>'xxx"<<<"                /*add fence before&after old text*/
say 'new = >>>'yyy"<<<"                /* "    "      "    "    new text*/
                                       /*stick a fork in it, we're done.*/

/*REXX program which allows a user to play the game of 24 (twenty-four).*/
/*
  ╔══════════════════════════════════════════════════════════════════╗
  ║ Argument is either of three forms:   (blank)                     ║
  ║                                      ssss                        ║
  ║                                      ssss-ffff                   ║
  ║                                                                  ║
  ║ where one or both strings must be exactly four numerals (digits) ║
  ║ comprised soley of the numerals (digits)  1 ──> 9   (no zeroes). ║
  ║                                                                  ║
  ║                                      SSSS  is the start,         ║
  ║                                      FFFF  is the start.         ║
  ║                                                                  ║
  ║ If no argument is specified, this program finds a four digit     ║
  ║ number (no zeroes)  which has at least one solution,  and shows  ║
  ║ the number to the user,  requesting that they enter a solution   ║
  ║ in the form of:    w  operator  x  operator  y  operator  z      ║
  ║ where   w  x  y  and  z   are single digit numbers  (no zeroes), ║
  ║ and    operator   can be any one of:     +    -    *    /        ║
  ║ Parentheses ()  may be used in the normal manner for grouping,   ║
  ║ as well as  brackets []  or  braces  {}.                         ║
  ╚══════════════════════════════════════════════════════════════════╝  */
parse arg orig                   /*get the  guess  from the argument.   */
orig=space(orig,0)               /*remove extraneous blanks from  ORIG. */
parse var orig start '-' finish  /*get the start and finish  (maybe).   */
finish=word(finish start,1)      /*if no  FINISH  specified, use  START.*/
opers='+-*/'                     /*define the legal arithmetic operators*/
ops=length(opers)                /* ... and the count of them (length). */
groupsymbols='()[]{}'            /*legal grouping symbols.              */
indent=left('',30)               /*used to indent display of solutions. */
Lpar='('                         /*a string to make REXX code prettier. */
Rpar=')'                         /*ditto.                               */
show=1                           /*flag used show solutions  (0 = not). */
digs=123456789                   /*numerals (digits) that can be used.  */

  do j=1 for ops                 /*define a version for fast execution. */
  o.j=substr(opers,j,1)
  end   /*j*/

if orig\=='' then do
                  sols=solve(start,finish)
                  if sols<0 then exit 13
                  if sols==0 then sols='No'         /*un-geek SOLS.*/
                  say
                  say sols 'unique solution's(finds) "found for" orig     /*pluralize.*/
                  exit
                  end
show=0                           /*stop SOLVE from blabbing solutions.  */
        do forever
        rrrr=random(1111,9999)
        if pos(0,rrrr)\==0 then iterate
        if solve(rrrr)\==0 then leave
        end
show=1                           /*enable SOLVE to show solutions.      */
rrrr=sort(rrrr)                  /*sort four elements.                  */
rd.=0
        do j=1 for 9             /*digit count # for each digit in RRRR.*/
        _=substr(rrrr,j,1)
        rd._=countdigs(rrrr,_)
        end   /*j*/

  do guesses=1;   say
  say 'Using the digits',
       rrrr", enter an expression that equals 24 (or QUIT):"
  pull y
  y=space(y,0);    if y=='QUIT' then exit
  _v=verify(y,digs||opers||groupsymbols)
  if _v\==0 then do
                 call ger 'invalid character:' substr(_v,1)
                 iterate
                 end
  yl=length(y)
  if y='' then do
               call validate y
               iterate
               end

    do j=1 to yl-1
    _=substr(y,j,1)
    if \datatype(_,'W') then iterate
    _=substr(y,j+1,1)
    if datatype(_,'W') then do
                            call ger 'invalid use of digit abuttal'
                            iterate guesses
                            end
    end   /*j*/

  yd=countdigs(y,digs)                  /*count of digits 123456789.*/
  if yd<4 then do
               call ger 'not enough digits entered.'
               iterate guesses
               end
  if yd>4 then do
               call ger 'too many digits entered.'
               iterate guesses
               end

    do j=1 for 9;   if rd.j==0 then iterate
    _d=countdigs(y,j)
    if _d==rd.j then iterate
    if _d<rd.j then call ger 'not enough' j "digits, must be" rd.j
               else call ger 'too many' j "digits, must be" rd.j
    iterate guesses
    end   /*j*/

  y=translate(y,'()()',"[]{}")
  signal on syntax
  interpret 'ans='y
  ans=ans/1
  if ans==24 then leave guesses
  say 'incorrect,' y'='ans
  end   /*guesses*/

say
say center('┌─────────────────────┐',79)
say center('│                     │',79)
say center('│  congratulations !  │',79)
say center('│                     │',79)
say center('└─────────────────────┘',79)
exit
/*───────────────────────────SOLVE subroutine───────────────────────────*/
solve: parse arg ssss,ffff       /*parse the argument passed to  SOLVE. */
if ffff=='' then ffff=ssss       /*create a   FFFF   if necessary.      */
if \validate(ssss) then return -1
if \validate(ffff) then return -1
finds=0                          /*number of found solutions (so far).  */
x.=0                             /*a method to hold unique expressions. */
                                 /*alternative:  indent=copies(' ',30)  */

  do g=ssss to ffff              /*process a (possible) range of values.*/
  if pos(0,g)\==0 then iterate   /*ignore values with zero in them.     */

      do j=1 for 4               /*define a version for fast execution. */
      g.j=substr(g,j,1)
      end   /*j*/

    do i=1 for ops               /*insert an operator after 1st number. */
      do j=1 for ops             /*insert an operator after 2nd number. */
        do k=1 for ops           /*insert an operator after 2nd number. */
          do m=0 to 4-1;  L.=""  /*assume no left parenthesis so far.   */
            do n=m+1 to 4        /*match left paren with a right paren. */
            L.m=Lpar             /*define a left paren, m=0 means ignore*/
            R.=""                /*un-define all right parenthesis.     */
            if m==1 & n==2 then L.=""       /*special case:  (n)+ ...   */
                           else if m\==0 then R.n=Rpar      /*no (, no )*/
            e = L.1  g.1  o.i  L.2  g.2  o.j  L.3  g.3  R.3  o.k  g.4  R.4
            e=space(e,0)         /*remove all blanks from the expression*/

                                 /*(below) change expression:           */
                                 /*       /(yyy)   ===>   /div(yyy)     */
                                 /*Enables to check for division by zero*/
            origE=e              /*keep old version for the display.    */
            if pos('/(',e)\==0 then e=changestr('/(',e,"/div(")
                                 /*The above could be replaced by:      */
                                 /*   e=changestr('/(',e,"/div(")       */

                                 /*INTERPRET stresses REXX's groin,     */
                                 /*so try to avoid repeated lifting.    */
            if x.e then iterate  /*was the expression already used?     */
            x.e=1                /*mark this expression as unique.      */
                                 /*have REXX do the heavy lifting.      */
            interpret 'x=' e
            x=x/1                /*remove trailing decimal points.      */
            if x\==24 then iterate            /*Not correct?  Try again.*/
            finds=finds+1        /*bump number of found solutions.      */
            _=translate(origE,'][',")(")       /*show  [],  not  ().*/
            if show then say indent 'a solution:' _  /*show solution*/
            end   /*n*/
          end     /*m*/
        end       /*k*/
      end         /*j*/
    end           /*i*/
  end             /*g*/

return finds
/*───────────────────────────COUNTDIGS subroutine───────────────────────*/
countdigs: arg field,numerals                /*count of digits NUMERALS.*/
return length(field)-length(space(translate(field,,numerals),0))
/*───────────────────────────DIV subroutine─────────────────────────────*/
div: procedure; parse arg q      /*tests if dividing by  0  (zero).     */
if q=0 then q=1e9                /*if dividing by zero, change divisor. */
return q                         /*changing Q invalidates the expression*/
/*───────────────────────────GER subroutine─────────────────────────────*/
ger: say; say '*** error! *** for argument:' y; say arg(1); say; errCode=1; return 0
/*───────────────────────────S subroutine───────────────────────────────*/
s: if arg(1)==1 then return '';   return 's'        /*simple pluralizer.*/
/*───────────────────────────SORT subroutine────────────────────────────*/
sort: procedure;  arg nnnn;  L=length(nnnn)

     do i=1 for L                 /*build an array of digits from  NNNN.*/
     a.i=substr(nnnn,i,1)         /*this enables SORT to sort an array. */
     end   /*i*/

  do j=1 for L;   _=a.j
         do k=j+1 to L
         if a.k<_ then  parse value  a.j  a.k    with    a.k  a.j
         end   /*k*/
  end          /*j*/
return a.1 || a.2 || a.3 || a.4
/*───────────────────────────SYNTAX subroutin───────────────────────────*/
syntax: call ger 'illegal syntax in' y; exit
/*───────────────────────────validate subroutine────────────────────────*/
validate: parse arg y;   errCode=0;   _v=verify(y,digs)
    select
    when y==''        then call ger 'no digits entered.'
    when length(y)<4  then call ger 'not enough digits entered, must be 4'
    when length(y)>4  then call ger 'too many digits entered, must be 4'
    when pos(0,y)\==0 then call ger "can't use the digit  0 (zero)"
    when _v\==0       then call ger 'illegal character:' substr(y,_v,1)
    otherwise nop
    end    /*select*/
return \errCode

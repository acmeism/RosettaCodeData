/*REXX program helps the user find solutions to the game of  24.                        */
/*                           start-of-help
┌───────────────────────────────────────────────────────────────────────┐
│ Argument is either of three forms:  (blank)                           │~
│                                      ssss                             │~
│                                      ssss,tot                         │~
│                                      ssss-ffff                        │~
│                                      ssss-ffff,tot                    │~
│                                     -ssss                             │~
│                                     +ssss                             │~
│                                                                       │~
│ where SSSS and/or FFFF must be exactly four numerals (digits)         │~
│ comprised soley of the numerals (digits)  1 ──> 9   (no zeroes).      │~
│                                                                       │~
│                                      SSSS  is the start,              │~
│                                      FFFF  is the start.              │~
│                                                                       │~
│                                                                       │~
│ If  ssss  has a leading plus (+) sign, it is used as the number, and  │~
│ the user is prompted to find a solution.                              │~
│                                                                       │~
│ If  ssss  has a leading minus (-) sign, a solution is looked for and  │~
│ the user is told there is a solution (but no solutions are shown).    │~
│                                                                       │~
│ If no argument is specified, this program finds a four digits (no     │~
│ zeroes)  which has at least one solution, and shows the digits to     │~
│ the user, requesting that they enter a solution.                      │~
│                                                                       │~
│ If  tot  is entered, it is the desired answer.  The default is  24.   │~
│                                                                       │~
│ A solution to be entered can be in the form of:                       │
│                                                                       │
│    digit1   operator   digit2   operator   digit3   operator  digit4  │
│                                                                       │
│ where    DIGITn     is one of the digits shown (in any order),  and   │
│          OPERATOR   can be any one of:     +    -    *    /           │
│                                                                       │
│ Parentheses  ()  may be used in the normal manner for grouping,  as   │
│ well as brackets  []  or  braces  {}.   Blanks can be used anywhere.  │
│                                                                       │
│ I.E.:    for the digits    3448     the following could be entered.   │
│                                                                       │
│                            3*8 + (4-4)                                │
└───────────────────────────────────────────────────────────────────────┘
                          end-of-help                                   */
numeric digits 12                                /*where rational arithmetic is needed. */
parse arg orig                                   /*get the  guess  from the command line*/
orig= space(orig, 0)                             /*remove all blanks from  ORIG.        */
negatory= left(orig,1)=='-'                      /*=1, suppresses showing.              */
pository= left(orig,1)=='+'                      /*=1, force $24 to use specific number.*/
if pository | negatory  then orig=substr(orig,2) /*now, just use the absolute vaue.     */
parse var orig orig ',' ??                       /*get ??  (if specified, def=24).      */
parse var orig start '-' finish                  /*get start and finish  (maybe).       */
opers= '*' || "/+-"                              /*legal arith. opers;order is important*/
ops= length(opers)                               /*the number of arithmetic operators.  */
groupsym= '()[]{}'                               /*allowed grouping symbols.            */
indent= left('', 30)                             /*indents display of solutions.        */
show= 1                                          /*=1, shows solutions (semifore).      */
digs= 123456789                                  /*numerals/digs that can be used.      */
abuttals = 0                                     /*=1, allows digit abutal:  12+12      */
if ??==''  then ??= 24                           /*the name of the game.                */
??= ?? / 1                                       /*normalize the answer.                */
@abc= 'abcdefghijklmnopqrstuvwxyz'               /*the Latin alphabet in order.         */
@abcu= @abc;  upper @abcu                        /*an uppercase version of @abc.        */
x.= 0                                            /*method used to not re-interpret.     */
      do j=1  for ops;    o.j=substr(opers, j, 1)
      end  /*j*/                                 /*used for fast execution.             */
y= ??
if \datatype(??,'N')       then do; call ger "isn't numeric"; exit 13;  end
if start\=='' & \pository  then do; call ranger start,finish; exit 13;  end
show= 0                                          /*stop SOLVE blabbing solutions.       */
        do forever  while  \negatory             /*keep truckin' until a solution.      */
        x.= 0                                    /*way to hold unique expressions.      */
        rrrr= random(1111, 9999)                 /*get a random set of digits.          */
        if pos(0, rrrr)\==0  then iterate        /*but don't the use of zeroes.         */
        if solve(rrrr)\==0  then leave           /*try to solve for these digits.       */
        end   /*forever*/

if left(orig,1)=='+'  then rrrr=start            /*use what's specified.                */
show= 1                                          /*enable SOLVE to show solutions.      */
rrrr= sortc(rrrr)                                /*sort four elements.                  */
rd.= 0
                do j=1  for 9                    /*count for each digit in  RRRR.       */
                _= substr(rrrr, j, 1);    rd._= countchars(rrrr, _)
                end
  do guesses=1;                 say
  say 'Using the digits' rrrr", enter an expression that equals" ?? '  (? or QUIT):'
  pull y;                       y= space(y, 0)
  if countchars(y, @abcu)>2  then exit           /*the user must be desperate.          */
  helpstart= 0
  if y=='?'  then do j=1  for sourceline()       /*use a lazy way to show help.         */
                  _= sourceline(j)
                  if p(_)=='start-of-help'  then do;  helpstart=1;  iterate;  end
                  if p(_)=='end-of-help'    then iterate guesses
                  if \helpstart             then iterate
                  if right(_,1)=='~'        then iterate
                  say '  ' _
                  end

  _v= verify(y, digs || opers || groupsym)       /*any illegal characters?              */
  if _v\==0  then do;   call ger 'invalid character:'  substr(y, _v, 1);   iterate;    end
  if y=''  then do;     call validate y;   iterate;    end

    do j=1  for length(y)-1  while \abuttals     /*check for two digits adjacent.       */
    if \datatype(substr(y,j,1),  'W') then iterate
    if  datatype(substr(y,j+1,1),'W') then do
                                           call ger 'invalid use of digit abuttal' substr(y,j,2)
                                           iterate guesses
                                           end
    end   /*j*/

  yd= countchars(y, digs)                        /*count of legal digits  123456789     */
  if yd<4  then do;  call ger 'not enough digits entered.'; iterate guesses; end
  if yd>4  then do;  call ger 'too many digits entered.'  ; iterate guesses; end

      do j=1  for length(groupsym)  by 2
      if countchars(y,substr(groupsym,j  ,1))\==,
         countchars(y,substr(groupsym,j+1,1))  then do
                                                    call ger 'mismatched' substr(groupsym,j,2)
                                                    iterate guesses
                                                    end
      end   /*j*/

        do k=1  for 2                            /*check for   **    and    //          */
        _= copies( substr( opers, k, 1), 2)
        if pos(_, y)\==0  then do;  call ger 'illegal operator:' _;  iterate guesses;  end
        end   /*k*/

    do j=1  for 9;    if rd.j==0  then iterate;     _d= countchars(y, j)
    if _d==rd.j  then iterate
    if _d<rd.j   then call ger  'not enough'   j   "digits, must be"   rd.j
                 else call ger  'too many'     j   "digits, must be"   rd.j
    iterate guesses
    end   /*j*/

  y= translate(y, '()()', "[]{}")
  interpret  'ans=('  y   ") / 1"
  if ans==??  then leave guesses
  say right('incorrect, ' y'='ans, 50)
  end   /*guesses*/

say;      say center('┌─────────────────────┐', 79)
          say center('│                     │', 79)
          say center('│  congratulations !  │', 79)
          say center('│                     │', 79)
          say center('└─────────────────────┘', 79)
say
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
countchars: procedure; arg x,c                   /*count of characters in  X.           */
            return length(x) - length( space( translate(x, ,c ),  0) )
/*──────────────────────────────────────────────────────────────────────────────────────*/
ranger: parse arg ssss,ffff                      /*parse args passed to this sub.       */
        ffff= p(ffff ssss)                       /*create a   FFFF   if necessary.      */
              do g=ssss  to ffff                 /*process possible range of values.    */
              if pos(0, g)\==0  then iterate     /*ignore any   G   with zeroes.        */
              sols= solve(g);  wols= sols
              if sols==0  then wols= 'No'        /*un-geek number of solutions (if any).*/
              if negatory & sols\==0  then wols='A'   /*found only the first solution?  */
              say
              say wols   'solution's(sols)    "found for"    g
              if ??\==24  then say  'for answers that equal'    ??
              end
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
solve: parse arg qqqq;   finds= 0                /*parse args passed to this sub.       */
if \validate(qqqq)  then return -1
parse value '( (( )) )' with L LL RR R           /*assign some static variables.        */
nq.= 0
           do jq=1  for 4;  _= substr(qqqq,jq,1) /*count the number of each digit.      */
           nq._= nq._ + 1
           end   /*jq*/

  do gggg=1111  to 9999
  if pos(0, gggg)\==0        then iterate        /*ignore values with zeroes.           */
  if verify(gggg, qqqq)\==0  then iterate
  if verify(qqqq, gggg)\==0  then iterate
  ng.= 0
         do jg=1  for 4;  _= substr(gggg, jg, 1) /*count the number of each digit.      */
         g.jg= _;         ng._= ng._ + 1
         end   /*jg*/
                          do kg=1  for 9         /*verify each number has same # digits.*/
                          if nq.kg\==ng.kg  then iterate gggg
                          end   /*kg*/
    do i    =1  for ops                          /*insert operator after 1st numeral.   */
      do j  =1  for ops                          /*  "        "      "   2nd    "       */
        do k=1  for ops                          /*  "        "      "   3rd    "       */
          do m=0  for 10;       !.=              /*nullify all grouping symbols (parens)*/
            select
            when m==1  then do; !.1=L;           !.3=R;                                end
            when m==2  then do; !.1=L;                              !.5=R;             end
            when m==3  then do; !.1=L;           !.3=R;   !.4=L;              !.6=R;   end
            when m==4  then do; !.1=L;   !.2=L;                               !.6=RR;  end
            when m==5  then do; !.1=LL;                             !.5=R;    !.6=R;   end
            when m==6  then do;          !.2=L;                     !.5=R;             end
            when m==7  then do;          !.2=L;                               !.6=R;   end
            when m==8  then do;          !.2=L;           !.4=L;              !.6=RR;  end
            when m==9  then do;          !.2=LL;                    !.5=R;    !.6=R;   end
            otherwise  nop
            end   /*select*/

          e= space(!.1 g.1 o.i      !.2 g.2 !.3 o.j      !.4 g.3 !.5 o.k       g.4 !.6, 0)
          if x.e  then iterate                   /*was the expression already used?     */
          x.e= 1                                 /*mark this expression as being used.  */
                          /*(below)  change the expression:   /(yyy)  ===>  /div(yyy)   */
          origE= e                               /*keep original version for the display*/
          pd= pos('/(', e)                       /*find pos of     /(      in  E.       */
          if pd\==0  then do                     /*Found?  Might have possible ÷ by zero*/
                          eo= e
                          lr= lastpos(')', e)    /*find last right )   */
                          lm= pos('-', e, pd+1)  /*find  -  after  (   */
                          if lm>pd & lm<lr  then e= changestr('/(',e,"/div(")   /*change*/
                          if eo\==e then if x.e  then iterate /*expression already used?*/
                          x.e= 1                 /*mark this expression as being used.  */
                          end
          interpret 'x=('   e   ") / 1"          /*have REXX do the heavy lifting here. */
          if x\==??  then do                     /*Not correct?   Then try again.       */
                          numeric digits 9;    x= x / 1              /*re-do evaluation.*/
                          numeric digits 12                          /*re-instate digits*/
                          if x\==?? then iterate /*Not correct?   Then try again.       */
                          end
          finds= finds + 1                       /*bump number of found solutions.      */
          if \show | negatory  then return finds
          _= translate(origE, '][', ")(")                        /*show  [],  not  ().  */
          if show  then say indent   'a solution for'  g':'  ??"="  _   /*show solution.*/
          end     /*m*/
        end       /*k*/
      end         /*j*/
    end           /*i*/
  end             /*gggg*/
return finds
/*──────────────────────────────────────────────────────────────────────────────────────*/
sortc: procedure;  arg nnnn;   L= length(nnnn)    /*sorts the chars NNNN                */
              do i=1  for L                       /*build array of digs from  NNNN,     */
              a.i= substr(nnnn, i, 1)             /*enabling SORT to sort an array.     */
              end   /*i*/

              do j=1  for L                       /*very simple sort, it's a small array*/
              _= a.j
                       do k=j+1  to L
                       if a.k<_  then  do;   a.j= a.k;     a.k= _;     _= a.k;    end
                       end   /*k*/
              end   /*j*/
       v= a.1
                       do m=2  to L;  v= v || a.m /*build a string of digs from  A.m    */
                       end   /*m*/
       return v
/*──────────────────────────────────────────────────────────────────────────────────────*/
validate: parse arg y;     errCode= 0;       _v= verify(y, digs)
                   select
                   when y==''         then call ger 'no digits entered.'
                   when length(y)<4   then call ger 'not enough digits entered, must be 4'
                   when length(y)>4   then call ger 'too many digits entered, must be 4'
                   when pos(0,y)\==0  then call ger "can't use the digit  0 (zero)"
                   when _v\==0        then call ger 'illegal character:' substr(y,_v,1)
                   otherwise               nop
                   end   /*select*/
          return \errCode
/*──────────────────────────────────────────────────────────────────────────────────────*/
div:  procedure; parse arg q; if q=0  then q=1e9; return q  /*tests if dividing by zero.*/
ger:  say= '***error*** for argument:'  y;      say arg(1);      errCode= 1;      return 0
p:    return word( arg(1), 1)
s:    if arg(1)==1  then return arg(3);           return word( arg(2) 's', 1)

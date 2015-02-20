/*REXX program which allows a user to play the game of  24  (twenty-four).    */
numeric digits 15                      /*allow more leeway when computing #s. */
parse arg yyy                          /*get the optional arguments from C.L. */
        yyy = space(yyy,0)             /*remove extraneous blanks from  YYY.  */
parse var yyy start '-' fin            /*get the START and FINish  (maybe).   */
         fin = word(fin start,1)       /*if no  FINish  specified, use  START.*/
       opers = '+-*/'                  /*define the legal arithmetic operators*/
         ops = length(opers)           /* ··· and the count of them (length). */
groupSymbols = '()[]{}'                /*legal grouping symbols for this game.*/
      indent = left('',30)             /*used to indent display of solutions. */
        Lpar = '('                     /*a string to make the output prettier.*/
        Rpar = ')'                     /*Ditto.     [You can say that again.] */
        digs = 123456789               /*numerals (digits)  that can be used. */
        show = 1                       /*flag used show solutions  (0 = not). */
                 do j=1  for ops       /*define a version for fast execution. */
                 @.j=substr(opers,j,1) /*assign each operation to an array.   */
                 end   /*j*/
signal on syntax                       /*enable program to trap syntax errors.*/
if yyy\=='' then do                    /*if START (or FINish), then solve 'em.*/
                 sols=solve(start,fin)      /*solve  START  ───►  FINish. */
                 if sols <0  then exit 13   /*Was there a problem with input? */
                 if sols==0  then sols='No' /*Englishize  the  SOLS  variable.*/
                 say;   say  sols   'unique solution's(sols)   "found for"   yyy
                 exit                       /*S    [↑]   does pluralizations. */
                 end
show=0                                 /*stop  SOLVE  from blabbing solutions.*/
        do  forever;         rrrr=random(1111, 9999)
        if pos(0, rrrr)\==0  then iterate      /*if contains a zero, ignore it*/
        if solve(rrrr)\==0   then leave        /*if solved, then stop looking.*/
        end   /*forever*/
show=1                                 /*enable  SOLVE  to display solutions. */
rrrr=sort(rrrr)                        /*sort four digits (for consistancy).  */
$.=0
        do j=1  for length(rrrr)       /*digit count for each digit in  RRRR. */
        _=substr(rrrr, j, 1)           /*pick off one of the digits in  RRRR. */
        $._=countDigs(rrrr, _)         /*define the count for this digit.     */
        end   /*j*/                    /* [↑] counts duplicates twice, no harm*/

prompt= 'Using the digits' rrrr", enter an expression that equals 24 (or QUIT):"
                                       /* [↓]  ITERATE  needs a variable name.*/
  do prompter=0;   say;   say prompt   /*display blank line and the prompt (P)*/
  pull y;         y=space(y,0)         /*get Y from CL, then remove all blanks*/
  if abbrev('QUIT',y,1)  then exit     /*Does the user want to quit this game?*/
  _v=verify(y, digs || opers || groupSymbols);         a=substr(y, max(1,_v), 1)
  if _v\==0       then do;  call ger  'invalid character:'  a;   iterate;    end
  if pos('**',y)  then do;  call ger  'invalid  **  operator';   iterate;    end
  if pos('//',y)  then do;  call ger  'invalid  //  operator';   iterate;    end
  yL=length(y)
  if y==''        then do;  call validate y;                     iterate;    end

            do j=1  for yL-1;  if \datatype(substr(y, j  ,1), 'W')  then iterate
                               if \datatype(substr(y, j+1,1), 'W')  then iterate
            call ger  'invalid use of  "digit abuttal".'
            iterate prompter
            end   /*j*/

  yd=countDigs(y, digs)                /*count of the digits 1──►9 (123456789)*/
  if yd<4  then do; call ger 'not enough digits entered.'; iterate prompter; end
  if yd>4  then do; call ger 'too many digits entered.'  ; iterate prompter; end

           do j=1  for 9;        if $.j==0   then iterate
           _d=countDigs(y, j);   if $.j==_d  then iterate
           if _d<$.j   then call ger 'not enough'  j  "digits, must be"  $.j
                       else call ger 'too many'    j  "digits, must be"  $.j
           iterate prompter
           end   /*j*/

  y=translate(y, '()()', "[]{}")
  interpret  'ans=' y;    ans=ans/1;   if ans==24  then leave prompter
  say  'incorrect, '  y'='ans
  end   /*prompter*/

say;            say center('┌─────────────────────┐', 79)
                say center('│                     │', 79)
                say center('│  congratulations !  │', 79)
                say center('│                     │', 79)
                say center('└─────────────────────┘', 79)
exit                                   /*stick a fork in it, we're all done.  */
/*──────────────────────────────────one─liner subroutines─────────────────────*/
countDigs: arg ?;   return  length(?) - length(space(translate(?, , arg(2)), 0))
div: if arg(1)=0  then return 7e9;  return  arg(1)   /*if ÷ by 0, fudge result*/
ger: say; say '***error!*** for argument:' y; say arg(1); say;errCode=1;return 0
s:   if arg(1)==1  then return '';            return 's'  /*simple pluralizer.*/
syntax: call ger  'illegal syntax in'  y;     exit
/*──────────────────────────────────SOLVE subroutine──────────────────────────*/
solve: parse arg ssss, ffff            /*parse the argument passed to  SOLVE. */
if ffff==''         then ffff=ssss     /*create a   FFFF   if necessary.      */
if \validate(ssss)  then return -1     /*validate the  SSSS  field.           */
if \validate(ffff)  then return -1     /*    "     "   FFFF    "              */
#=0                                    /*number of found solutions (so far).  */
!.=0                                   /*a method to hold unique expressions. */
                                       /*alternative:  indent=copies(' ',30)  */

  do g=ssss  to ffff                   /*process a (possible) range of values.*/
  if pos(0, g)\==0  then iterate       /*ignore values with zero in them.     */

      do j=1  for 4                    /*define a version for fast execution. */
      g.j=substr(g, j, 1)              /*extract each digit of  G  into array.*/
      end   /*j*/

    do i      =1  for ops              /*insert an operator after 1st number. */
      do j    =1  for ops              /*insert an operator after 2nd number. */
        do k  =1  for ops              /*insert an operator after 2nd number. */
          do m=0  to  3;    L.=        /*assume no left parenthesis so far.   */
            do n=m+1  to 4             /*match left paren with a right paren. */
            L.m=Lpar                   /*define a left paren, m=0 means ignore*/
            R.=                        /*un-define all right parenthesis.     */
            if m==1 & n==2  then L.=   /*special case of :   (n)  +  ···      */
                            else if m\==0  then R.n=Rpar          /*no (, no )*/
            e = L.1  g.1  @.i  L.2  g.2  @.j  L.3  g.3  R.3  @.k  g.4  R.4
            e=space(e, 0)              /*remove all blanks from the expression*/
                                       /* [↓]  change expression:             */
                                       /*       /(yyy)   ═══►   /div(yyy)     */
                                       /*Enables to check for division by zero*/
            yyyE=e                     /*keep old the version for the display.*/
            if pos('/(', e)\==0  then e=changestr( '/(',  e,  "/div("  )
                                       /* [↓] INTERPRET stresses REXX's groin,*/
                                       /*    so try to avoid repeated lifting.*/
            if !.e  then iterate       /*was this expression already used?    */
            !.e=1                      /*mark this expression as being used.  */
            interpret  'x='  e         /*have REXX do all the heavy lifting   */
            x=x/1                      /*remove any trailing decimal point.   */
            if x\==24  then iterate    /*Is the result incorrect?  Try again. */
            #=#+1                      /*bump number of found solutions.      */
            _=translate(yyyE, '][', ")(")           /*display  [],  not  (). */
            if show  then say indent  'a solution:'  _
            end   /*n*/                              /* [↑]   show a solution.*/
          end     /*m*/
        end       /*k*/
      end         /*j*/
    end           /*i*/
  end             /*g*/

return #
/*──────────────────────────────────SORT subroutine───────────────────────────*/
sort: procedure;  arg nnnn;  L=length(nnnn)

     do i=1  for L                     /*build an array of digits from  NNNN. */
     s.i=substr(nnnn, i, 1)            /*this enables SORT to sort an array.  */
     end   /*i*/

  do j=1  for L;   _=s.j
         do k=j+1  to L
         if s.k<_  then  parse  value    s.j  s.k      with      s.k  s.j
         end   /*k*/
  end          /*j*/
return s.1 || s.2 || s.3 || s.4
/*──────────────────────────────────VALIDATE subroutine───────────────────────*/
validate: parse arg y;   errCode=0;   _v=verify(y,digs)
    select
    when y==''         then call ger 'no digits entered.'
    when length(y)<4   then call ger 'not enough digits entered,  must be four.'
    when length(y)>4   then call ger 'too many digits entered,  must be four.'
    when pos(0,y)\==0  then call ger "can't use the digit  0 (zero)."
    when _v\==0        then call ger 'illegal character: '   substr(y,_v,1)
    otherwise          nop
    end    /*select*/
return \errCode

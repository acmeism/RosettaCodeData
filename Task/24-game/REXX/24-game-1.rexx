/*REXX program supports a human to play the game of 24 (twenty-four) with error checking*/
parse arg yyy;      yyy=space(yyy, 0)            /*get optional CL args;  elide blanks. */
parse var  yyy      start  '-'  fin              /*get the START and FINish  (maybe).   */
     fin= word(fin start, 1)                     /*if no  FINish  specified, use  START.*/
     ops= '+-*/'        ;  Lops= length(0ps)     /*define the legal arithmetic operators*/
groupSym= '()[]{}'                               /*legal grouping symbols for this game.*/
  pad= left('', 30)                              /*used to indent display of solutions. */
    Lpar= '('           ;  Rpar= ')'             /*strings to make the output prettier.*/
    digs= 123456789                              /*numerals (digits)  that can be used. */
    show= 1                                      /*flag used show solutions  (0 = not). */
                  do j=1 for Lops;  @.j=substr(ops,j,1);  end     /*for fast execution. */
signal on syntax                                 /*enable program to trap syntax errors.*/
if yyy\==''  then do; sols=solve(start, fin)     /*solve  from  START  ───►  FINish.    */
                      if sols <0  then exit 13   /*Was there a problem with the input?  */
                      if sols==0  then sols='No' /*Englishize  the  SOLS  variable value*/
                      say;   say  sols   'unique solution's(sols)      "found for"     yyy
                      exit                       /*S    [↑]   does pluralizations.      */
                  end
show=0                                           /*stop  SOLVE  from blabbing solutions.*/
        do  forever;         rrrr=random(1111, 9999)
        if pos(0, rrrr)\==0  then iterate        /*if it contains a zero, then ignore it*/
        if solve(rrrr) \==0  then leave          /*if solved, then we can stop looking. */
        end   /*forever*/
show=1                                           /*enable  SOLVE  to display solutions. */
rrrr=sort(rrrr);    Lrrrr=length(rrrr)           /*sort four digits (for consistency).  */
$.=0
        do j=1  for Lrrrr;   _=substr(rrrr,j,1)  /*digit count for each digit in  RRRR. */
        $._= countDigs(rrrr, _)                  /*define the count for this digit.     */
        end   /*j*/                              /* [↑] counts duplicates twice, no harm*/
                             __ = copies('─', 9) /*used for output highlighting.        */
prompt= 'Using the digits ' rrrr",  enter an expression that equals   24    (or QUIT):"
                                                 /* [↓]  ITERATE  needs a variable name.*/
  do prompter=0  by 0;     say;    say __ prompt /*display blank line and the prompt (P)*/
  pull y;                  y=space(y, 0)         /*get Y from CL, then remove all blanks*/
  if abbrev('QUIT', y, 1)  then exit 0           /*Does the user want to quit this game?*/
  _v=verify(y, digs || ops || groupSym);                         a=substr(y, max(1,_v), 1)
  if _v\==0        then do;  call ger  "invalid character:"  a;   iterate;    end
  if pos('**', y)  then do;  call ger  "invalid  **  operator";   iterate;    end
  if pos('//', y)  then do;  call ger  "invalid  //  operator";   iterate;    end
  Ly=length(y)
  if y==''         then do;  call validate y;                     iterate;    end
                        do j=1  for Ly-1; if \datatype(substr(y,j  ,1), 'W')  then iterate
                                          if \datatype(substr(y,j+1,1), 'W')  then iterate
                        call ger  'invalid use of  "digit abuttal".'
                        iterate prompter
                        end   /*j*/
  yd=countDigs(y,digs)                           /*count of the digits 1──►9 (123456789)*/
  if yd<4  then do;  call ger 'not enough digits entered.';   iterate  /*prompter*/;   end
  if yd>4  then do;  call ger 'too many digits entered.'  ;   iterate  /*prompter*/;   end
                do j=1  for 9;             if $.j==0   then iterate
                _d=countDigs(y, j);        if $.j==_d  then iterate
                if _d<$.j   then call ger  'not enough'   j   "digits, must be"   $.j
                            else call ger  'too many'     j   "digits, must be"   $.j
                iterate prompter
                end   /*j*/
  interpret  'ans='  translate(y, '()()', "[]{}");    ans=ans/1
  if ans==24  then leave prompter;                    say  'incorrect, '    y"="ans
  end   /*prompter*/

say;            say center('┌─────────────────────┐',  79)
                say center('│                     │',  79)
                say center('│  congratulations !  │',  79)
                say center('│                     │',  79)
                say center('└─────────────────────┘',  79)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
countDigs: arg ?;   return  length(?) - length(space(translate(?, , arg(2)), 0))
div:       if arg(1)=0  then return 7e9;  return  arg(1)          /*÷ by 0? Fudge result*/
ger:       say; say __ '***error*** for expression:' y; say __ arg(1); say; OK=0; return 0
s:         if arg(1)==1  then return '';             return "s"   /*a simple pluralizer.*/
syntax:    call ger  'illegal syntax in'  y;      exit
/*──────────────────────────────────────────────────────────────────────────────────────*/
solve: parse arg ssss, ffff                      /*parse the argument passed to  SOLVE. */
       if ffff==''  then ffff=ssss               /*create a   FFFF   if necessary.      */
       if \validate(ssss) | \validate(ffff)  then return -1       /*validate SSSS & FFFF*/
       !.=0;        #=0                          /*holds unique expressions; # solutions*/
         do g=ssss  to ffff                      /*process a (possible) range of values.*/
         if pos(0, g)\==0  then iterate          /*ignore values with zero in them.     */
                   do j=1  for 4;  g.j=substr(g,j,1);  end         /*for fast execution.*/
           do i      =1  for Lops                /*insert an operator after 1st number. */
             do j    =1  for Lops                /*   "    "     "      "   2nd    "    */
               do k  =1  for Lops                /*   "    "     "      "   3rd    "    */
                 do m=0  to  3;    L.=           /*assume no left parenthesis  (so far).*/
                   do n=m+1  to 4; L.m=Lpar; R.= /*match left paren with a right paren. */
                   if m==1 & n==2  then L.=      /*special case of :   (n)  +  ···      */
                                   else if m\==0  then R.n=Rpar             /*no (, no )*/
                   e= L.1  g.1  @.i     L.2  g.2  @.j     L.3  g.3  R.3     @.k  g.4  R.4
                   e=space(e, 0)                 /*remove all blanks from the expression*/
                   yyyE=e                        /*keep old the version for the display.*/
                                                 /* [↓] change   /(yyy)  ═══► /div(yyy) */
                   if pos('/(', e)\==0  then e=changestr( "/(",  e,  '/div('  )
                   if !.e  then iterate          /*was this expression already used?    */
                   !.e=1                         /*mark this expression as being used.  */
                   interpret  'x='  e            /*have REXX do all the heavy lifting   */
                   if x\=24  then iterate        /*Is the result incorrect?  Try again. */
                   #=#+1                         /*bump number of found solutions.      */
                   if show  then say pad 'a solution for' g": "  translate(yyyE,'][',")(")
                   end   /*n*/                   /* [↑]   display a (single) solution.  */
                 end     /*m*/
               end       /*k*/
             end         /*j*/
           end           /*i*/
         end             /*g*/
       return #
/*──────────────────────────────────────────────────────────────────────────────────────*/
sort: procedure; parse arg #;  L=length(#);  !.=      /*this is a modified   bin   sort.*/
                            do d=1  for L;  _=substr(#, d, 1);  !.d=!.d || _;   end  /*d*/
      return space(!.0 !.1 !.2 !.3 !.4 !.5 !.6 !.7 !.8 !.9, 0)     /*reconstitute the #.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
validate: parse arg y;  OK=1;  _v=verify(y,digs); DE='digits entered, there must be four.'
              select
              when y==''         then call ger         "no"  DE
              when length(y)<4   then call ger "not enough"  DE
              when length(y)>4   then call ger   "too many"  DE
              when pos(0,y)\==0  then call ger "can't use the digit  0 (zero)."
              when _v\==0        then call ger "illegal character: "      substr(y, _v, 1)
              otherwise          nop
              end    /*select*/;               return OK

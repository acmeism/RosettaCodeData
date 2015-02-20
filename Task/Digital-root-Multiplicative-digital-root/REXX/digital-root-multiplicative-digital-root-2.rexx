/*REXX pgm finds persistence and multiplicative digital root of some #'s*/
numeric digits 2000                    /*increase the number of digits. */
parse arg target x; if \datatype(target,'W')  then target=25  /*default?*/
if x=''  then x=123321 7739 893 899998  /*use the defaults for  X ?     */
say center('number',8)  ' persistence   multiplicative digital root'
say copies('─'     ,8)  ' ───────────   ───────────────────────────'
                                       /* [↑]  title  and  separator.   */
     do j=1  for words(x);  n=abs(word(x,j))   /*process each # in list.*/
     parse value mdr(n)  with  mp mdr  /*obtain the persistence and MDR.*/
     say right(n,8) center(mp,13) center(mdr,30)   /*display #, mp, mdr.*/
     end   /*j*/                       /* [↑] show MP and MDR for each #*/
say                                    /* [↓] show a blank & title line.*/
say 'MDR       first '  target  " numbers that have a matching MDR"
say '═══  ' copies("═",(target+(target+1)**2)%2)   /*display a sep line.*/

     do k=0  for 9;  hits=0;  _=       /*show #'s that have an MDR of K.*/
     if k==7  then _=@7;   else        /*handle special seven case.     */

       do m=k  until hits==target      /*find target #s with an MDR of K*/
       ?=right(m,1)                    /*obtain right-most digit of  M. */
       if k\==0 then if ?==0             then iterate
       if k==5  then if ?//2==0          then iterate
       if k==1  then m=copies(1,hits+1)
                else if mdr(m,1)\==k     then iterate
       hits=hits+1;  _=space(_ m)      /*yes, we got a hit, add to list.*/

       if k==3  then do;  o=strip(m,'T',1)         /*strip trailing ones*/
                     if o==3 then m=copies(1,length(m))3 /*make new  M. */
                             else do;   t=pos(3,m)-1     /*position of 3*/
                                  m=overlay(3,translate(m,1,3),t)
                                  end  /* [↑] shift the "3" 1 place left*/
                     m=m-1             /*adjust for DO index advancement*/
                     end               /* [↑]  a shortcut to do DO index*/
       end   /*m*/                     /* [↑]  built a list of MDRs = k */

     say " "k':     ['_"]"             /*display the  K  (mdr) and list.*/
     if k==3  then @7=translate(_,7,k) /*save for later, special 7 case.*/
     end     /*k*/                     /* [↑]  done with the K mdr list.*/
@.=                                    /* [↓]  handle MDR of 9 special. */
_=translate(@7,9,7)                    /*translate a string for MDR 9.  */
@9=translate(_,,',')                   /*remove trailing commas from #'s*/
@3=                                    /*assine null string before build*/
   do j=1  for words(@9)               /*process each number for MDR 9. */
   _=space(translate(word(@9,j),,9),0) /*remove  "9"s  using  SPACE(x,0)*/
   L=length(_)+1                       /*use a "fudged" length of the #.*/
   new=                                /*this is the new numbers so far.*/
      do k=0 for L;    q=insert(3,_,k) /*insert the  1st  "3" into the #*/
        do i=k  to L;  z=insert(3,q,i) /*   "    "   2nd  "3"   "   "  "*/
        if @.z\==''  then iterate      /*if already define, ignore the #*/
        @.z=z;  new=z new              /*define it, and then add to list*/
        end   /*i*/                    /* [↑]  end of 2nd insertion of 3*/
      end     /*k*/                    /* [↑]   "  "  1st     "      " "*/
   @3=space(@3 new)                    /*remove blanks, then add to list*/
   end        /*j*/                    /* [↑]  end of insertion of "3"s.*/

a1=@9;  a2=@3;  @=                     /*define three strings for merge.*/
                                       /* [↓]  merge two lists, 3s & 9s.*/
      do  while  a1\=='' & a2\==''     /*process while the lists ¬empty.*/
      x=word(a1,1); y=word(a2,1); if x=='' | y=='' then leave   /*empty?*/
      if x<y  then do;  @=@ x;  a1=delword(a1,1,1);  end        /*add X.*/
              else do;  @=@ y;  a2=delword(a2,1,1);  end        /*add Y.*/
      end   /*while ···*/              /* [+]  only process just 'nuff. */
@=subword(@,1,target)                  /*elide the last trailing comma. */
say " "9':     ['@"]"                  /*display the  9  (mdr) and list.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────MDR subroutine──────────────────────*/
mdr: procedure;  parse arg y,s         /*get the number and find the MDR*/
   do p=1  until  y<10                 /*find multiplicative digRoot (Y)*/
   parse var y 1 r 2;  do k=2  to length(y);  r=r*substr(y,k,1); end;  y=r
   end   /*p*/                         /*wash, rinse, repeat ···        */
if s==1  then return r                 /*return multiplicative dig root.*/
              return p r               /*return the persistence and MDR.*/

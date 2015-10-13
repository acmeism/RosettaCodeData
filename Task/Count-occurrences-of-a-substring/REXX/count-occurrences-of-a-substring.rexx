/*REXX pgm counts the occurrences of a (non─overlapping) substring in a string*/
w=.                                                        /*max. width so far.*/
bag='the three truths'   ;     x='th'     ;      call showResult
bag='ababababab'         ;     x='abab'   ;      call showResult
bag='aaaabacad'          ;     x='aa'     ;      call showResult
bag='abaabba*bbaba*bbab' ;     x='a*b'    ;      call showResult
bag='abaabba*bbaba*bbab' ;     x=' '      ;      call showResult
bag=                     ;     x='a'      ;      call showResult
bag=                     ;     x=         ;      call showResult
bag='catapultcatalog'    ;     x='cat'    ;      call showResult
bag='aaaaaaaaaaaaaa'     ;     x='aa'     ;      call showResult
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
countstr:  procedure;  parse arg haystack,needle,start    /*get the arguments.*/
if start==''  then start=1;  width=length(needle)
                               do $=0  until p==0;  p=pos(needle,haystack,start)
                               start=p+width              /*prevent overlaps. */
                               end   /*$*/
return $                                                  /*return the count. */
/*────────────────────────────────────────────────────────────────────────────*/
showResult:  _= '═'                    /*the char (double bar) used in title. */
if w==. then do;  w=30;  n=w%2         /*W:  width of largest haystack;  N=½W */
             say center('haystack',w  ) center('needle',n  ) center('count',5  )
             say center(''        ,w,_) center(''      ,n,_) center(''     ,5,_)
             end
                                       /* [↓]  handle showing of null strings.*/
if bag==''  then bag=' (null)'
if   x==''  then   x=' (null)'
say left(bag,w)  left(x,n)  center(countstr(bag,x),5)    /*display the result.*/
return

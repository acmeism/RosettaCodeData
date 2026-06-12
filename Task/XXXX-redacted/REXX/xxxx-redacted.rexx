/*REXX program redacts a string (using Xs) from a text, depending upon specified options*/
       zDefault= 'Tom? Toms bottom tomato is in his stomach while playing the "Tom-tom"' ,
                 "brand tom-toms. That's so tom."
parse arg x '~' z                                /*obtain optional arguments from the CL*/
if x=='' | x==","  then x= 'Tom tom t'           /*Not specified?  Then use the default.*/
if z= '' | z= ","  then z= zDefault              /* "      "         "   "   "     "    */
options= 'w│s│n w│i│n p│s│n p│i│n p│s│o p│i│o'   /*most glyphs can be used instead of │ */
call build                                       /*build some stemmed arrays for REDACT.*/
           do j=1  for words(x);   q= word(x, j) /*process each of the  needle  strings.*/
           if j==1  then say 'haystack'  z       /*show a title if this is the 1at time.*/
           say;          say 'needle: '  q
               do k=1  for words(options);  useOpt= word(options, k)
               say ' ['useOpt"]"   redact(useOpt, q)
               end   /*k*/
           end       /*j*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
build:  #= words(z);                     ?= '█';           !.=
                        do i=1  for #;   n= word(z, i);    n= elide(n, 'HEAD',1   )
                                                           n= elide(n, 'TAIL',,,-1)
                        @.0.i= n;  upper n;  @.1.i= n
                        end   /*k*/;                       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
elide:  parse arg $, hot, LO, HI, inc;             L= length($);      inc= word(inc 1, 1)
        if LO==''  then LO=L;  if HI==''  then HI= L
                        do k=LO  for HI  by inc;                        _= substr($, k, 1)
                        if datatype(_, 'M')  then leave;          !.hot.i= !.hot.i  ||  _
                        if inc==1  then $= substr($, 2)           /*hot ≡ Heads Or Tails*/
                                   else $= left($, length($) - 1)
                        end   /*k*/;                   return $   /*elides punctuation. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
opt:    parse arg wop;  oU= option;  upper oU wop;     return pos(wop, oU) \== 0
/*──────────────────────────────────────────────────────────────────────────────────────*/
redact: parse arg option,qq; nz=; lu= 0; ww= opt('w'); pp= \ww; ii= opt('i'); oo= opt('o')
        qu= qq;   upper qu;  Lqq= length(qq);    if ii  then do;  upper qq;  lu= 1;  end
               do r=1  for #;  a= @.lu.r;  na= @.0.r;   La= length(a)
               if ww  then if a==qq  then na= copies(?, Lqq)
               if pp  then do 1;  _= pos(qq, a);   if _==0  then leave
                                  nn= na;  if ii  then upper nn
                                              do La;  _= pos(qq, nn);  if _==0  then leave
                                              na= overlay(?, na, _, Lqq, ?);
                                              nn= na;  if ii  then upper nn
                                              end   /*La*/
                           end   /*1*/
               if oo  then  if pos(?, na)\==0  then na= copies(?, length(na) )
               nz= nz !.head.r  ||  na  ||  !.tail.r
               end   /*r*/
        return strip( translate(nz, 'X', ?) )

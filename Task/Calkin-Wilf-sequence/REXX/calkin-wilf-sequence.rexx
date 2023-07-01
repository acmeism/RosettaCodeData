/*REXX pgm finds the Nth value of the  Calkin─Wilf  sequence (which will be a fraction),*/
/*────────────────────── or finds which sequence number contains a specified fraction). */
numeric digits 2000                              /*be able to handle ginormic integers. */
parse arg LO HI te .                             /*obtain optional arguments from the CL*/
if LO=='' | LO==","   then LO=  1                /*Not specified?  Then use the default.*/
if HI=='' | HI==","   then HI= 20                /* "      "         "   "   "     "    */
if te=='' | te==","   then te= '/'               /* "      "         "   "   "     "    */
if datatype(LO, 'W')  then call CW_terms         /*Is LO numeric?  Then show some terms.*/
if pos('/', te)>0     then call CW_frac  te      /*Does TE have a / ?   Then find term #*/
exit 0
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
th:     parse arg th; return word('th st nd rd', 1+(th//10) *(th//100%10\==1) *(th//10<4))
/*──────────────────────────────────────────────────────────────────────────────────────*/
CW_frac:   procedure; parse arg p '/' q .;       say
           if q==''  then do;  p= 83116;         q= 51639;  end
           n= rle2dec( frac2cf(p q) );                    @CWS= 'the Calkin─Wilf sequence'
           say 'for '  p"/"q',  the element number for'   @CWS    "is: "    commas(n)th(n)
           if length(n)<10  then return
           say;  say 'The above number has '     commas(length(n))      " decimal digits."
           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
CW_term:   procedure;  parse arg z;                 dd= 1;               nn= 0
                                       do z
                                       parse value  dd  dd*(2*(nn%dd)+1)-nn   with  nn  dd
                                       end   /*z*/
           return nn'/'dd
/*──────────────────────────────────────────────────────────────────────────────────────*/
CW_terms:  $=;        if LO\==0  then  do j=LO  to HI;   $= $  CW_term(j)','
                                       end   /*j*/
           if $==''  then return
           say 'Calkin─Wilf sequence terms for '  commas(LO)  " ──► "  commas(HI)  ' are:'
           say strip( strip($), 'T', ",")
           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
frac2cf:   procedure;  parse arg p q;  if q==''  then return p;          cf= p % q;   m= q
           p= p - cf*q;                n= p;        if p==0  then return cf
                         do k=1  until n==0;        @.k= m % n
                         m= m  -  @.k * n;    parse value  n m   with   m n   /*swap N M*/
                         end   /*k*/
                                              /*for inverse Calkin─Wilf, K must be even.*/
           if k//2  then do;  @.k= @.k - 1;   k= k + 1;    @.k= 1;   end
                         do k=1  for k;       cf= cf @.k;            end  /*k*/
           return cf
/*──────────────────────────────────────────────────────────────────────────────────────*/
rle2dec:   procedure;  parse arg f1 rle;                       obin= copies(1, f1)
                               do until rle=='';               parse var rle f0 f1 rle
                               obin= copies(1, f1)copies(0, f0)obin
                               end   /*until*/
           return x2d( b2x(obin) )            /*RLE2DEC: Run Length Encoding ──► decimal*/

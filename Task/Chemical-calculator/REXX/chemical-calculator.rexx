/*REXX program  calculates the   molar mass   from a specified chemical formula.        */
numeric digits 30                                /*ensure enough decimal digits for mass*/
/*─────────── [↓]  table of known elements (+2 more) with their atomic mass ────────────*/
@.=             ;  @.Co= 58.933195 ;  @.H =  1.00794   ;  @.Np=237       ;  @.Se= 78.96
                   @.Cr= 51.9961   ;  @.In=114.818     ;  @.N = 14.0067  ;  @.Sg=266
@.Ac=227        ;  @.Cs=132.9054519;  @.Ir=192.217     ;  @.Og=294       ;  @.Si= 28.0855
@.Ag=107.8682   ;  @.Cu= 63.546    ;  @.I =126.904     ;  @.Os=190.23    ;  @.Sm=150.36
@.Al= 26.9815386;  @.C = 12.0107   ;  @.Kr= 83.798     ;  @.O = 15.9994  ;  @.Sn=118.710
@.Am=243        ;  @.Db=262        ;  @.K = 39.0983    ;  @.Pa=231.03588 ;  @.Sr= 87.62
@.Ar= 39.948    ;  @.Ds=271        ;  @.La=138.90547   ;  @.Pb=207.2     ;  @.S = 32.065
@.As= 74.92160  ;  @.Dy=162.500    ;  @.Li=  6.941     ;  @.Pd=106.42    ;  @.Ta=180.94788
@.At=210        ;  @.Er=167.259    ;  @.Lr=262         ;  @.Pm=145       ;  @.Tb=158.92535
@.Au=196.966569 ;  @.Es=252        ;  @.Lu=174.967     ;  @.Po=210       ;  @.Tc= 98
@.Ba=137.327    ;  @.Eu=151.964    ;  @.Lv=292         ;  @.Pr=140.90765 ;  @.Te=127.60
@.Be=  9.012182 ;  @.Fe= 55.845    ;  @.Mc=288         ;  @.Pt=195.084   ;  @.Th=232.03806
@.Bh=264        ;  @.Fl=289        ;  @.Md=258         ;  @.Pu=244       ;  @.Ti= 47.867
@.Bi=208.98040  ;  @.Fm=257        ;  @.Mg= 24.3050    ;  @.P = 30.973762;  @.Tl=204.3833
@.Bk=247        ;  @.Fr=223        ;  @.Mn= 54.938045  ;  @.Ra=226       ;  @.Tm=168.93421
@.Br= 79.904    ;  @.F = 18.9984032;  @.Mo= 95.94      ;  @.Rb= 85.4678  ;  @.Ts=293
@.B = 10.811    ;  @.Ga= 69.723    ;  @.Mt=268         ;  @.Re=186.207   ;  @.U =238.02891
@.Ca= 40.078    ;  @.Gd=157.25     ;  @.Na= 22.98976928;  @.Rf=261       ;  @.V = 50.9415
@.Cd=112.411    ;  @.Ge= 72.64     ;  @.Nb= 92.906     ;  @.Rg=272       ;  @.W =183.84
@.Ce=140.116    ;  @.He=  4.002602 ;  @.Nd=144.242     ;  @.Rh=102.905   ;  @.Xe=131.293
@.Cf=251        ;  @.Hf=178.49     ;  @.Ne= 20.1797    ;  @.Rn=220       ;  @.Yb=173.04
@.Cl= 35.453    ;  @.Hg=200.59     ;  @.Nh=284         ;  @.Ru=101.07    ;  @.Y = 88.90585
@.Cm=247        ;  @.Ho=164.930    ;  @.Ni= 58.6934    ;  @.Sb=121.760   ;  @.Zn= 65.409
@.Cn=285        ;  @.Hs=277        ;  @.No=259         ;  @.Sc= 44.955912;  @.Zr= 91.224
                                                          @.Ubn=299      ;  @.Uue=315
parse arg $;                                            _ = '─'
say center(' chemical formula        {common name} ', 45)      center("molar mass", 16)
say center(''                                       , 45, _)   center(''          , 16, _)
if $='' | $=","  then $= 'H{hydrogen}   H2{molecular_hydrogen}   H2O2{hydrogen_peroxide}',
                         '(HO)2{hydrogen_peroxide}   H2O{water}   Na2SO4{sodium_sulfate}',
                         'C6H12{cyclohexane}         COOH(C(CH3)2)3CH3{butyric_acid}'    ,
                         'C6H4O2(OH)4{vitamin_C}  C27H46O{cholesterol}   Uue{ununennium}',
                         'Mg3Si4O10(OH)2{talc}'
  do j=1  for words($);   x= word($, j)          /*obtain the formula of the molecule.  */
  parse var  x    x  '{'  -0  name               /*   "    "     "    and also a name.  */
  mm= chemCalc(x)                                /*   "    "  molar mass.               */
  name= strip(x '   'translate(name, 'ff'x,"_")) /*   "    "  molar mass; fix─up name.  */
  if mm<0  then iterate                          /*if function had an error, skip output*/
  say ' 'justify(name, 45-2)    "  "     mm      /*show chemical name and its molar mass*/
  end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
chemCalc: procedure expose @.; parse arg z       /*obtain chemical formula of molecule. */
          lev= 0                                 /*indicates level of parentheses depth.*/
          $.= 0                                  /*the sum of the molar mass  (so far). */
               do k=1  to  length(z);              y= substr(z, k, 1)      /*get a thing*/
               if y=='('  then do;  lev= lev + 1;  iterate k;  end
               if y==')'  then do;  y= substr(z, k+1, 1)
                                    if \datatype(y, 'W')  then do; say "illegal number:" y
                                                                   return -1
                                                               end
                                    n= getNum()                            /*get number.*/
                                    $.lev= $.lev * n;  $$= $.lev; $.lev= 0 /*sum level. */
                                    lev= lev - 1;      $.lev= $.lev + $$   /*add to prev*/
                                    k= k + length(n)                       /*adjust  K. */
                                    iterate   /*k*/
                               end                                         /*[↑] get ele*/
               e=y;   e= getEle();                     upper e             /* and upper.*/
               if   e==.  then do;  say 'missing element: '  e;   return -2;    end
               if @.e==.  then do;  say 'invalid element: '  e;   return -3;    end
               y= substr(z, k+length(e), 1)
               k= k + length(e) - 1                                        /*adjust  K. */
               n= getNum()                                                 /*get number.*/
               if n\==.  then k= k + length(n)                             /*adjust  K. */
                         else n= 1                                         /*no number. */
               $.lev= $.lev   +   n * @.e                                  /*add product*/
               end   /*k*/
          return format($.lev, max(4, pos(., $.lev) ) )                    /*align the #*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
getEle:   if \datatype(y, 'U')  then do;  say err "illegal element: "   y;  return .;  end
                         do i=1  until \datatype(q, 'L');  q= substr(z, k+i, 1)
                         if datatype(q, 'L')  then e= e || q               /*lowercase? */
                         end   /*i*/;                         return e
/*──────────────────────────────────────────────────────────────────────────────────────*/
getNum:   if \datatype(y, 'W')  then return .;             n=
                         do i=1  until \datatype(q, 'W');  q= substr(z, k+i, 1)
                         if datatype(q, 'W')  then n= n || q               /*is a digit?*/
                         end   /*i*/;                         return n

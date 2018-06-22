/*REXX pgm does a topological sort (orders such that no item precedes a dependent item).*/
iDep.=0;        iPos.=0;           iOrd.=0       /*initialize some stemmed arrays to  0.*/
nL=15;          nd=44;             nc=69         /*     "       "  "parms"  and indices.*/
label= 'DES_SYSTEM_LIB  DW01  DW02  DW03  DW04  DW05  DW06  DW07  DWARE  GTECH  RAMLIB',
       'STD_CELL_LIB  SYNOPSYS  STD  IEEE'
iCode=1 14 13 12 1 3 2 11 15 0 2 15 2 9 10 0 3 15 3 9 0 4 14 213 9 4 3 2 15 10 0 5 5 15 2,
      9 10 0 6 6 15 9 0 7 7 15 9 0 8 15 9 0 39 15 9 0 10 15 10 0 11 14 15 0 12 15 12 0 0
j=0
            do i=1
            iL=word(iCode, i);       if iL==0  then leave
               do forever;           i=i + 1
               iR=word(iCode, i);    if iR==0  then leave
               j=j + 1
               iDep.j.1= iL
               iDep.j.2= iR
               end   /*forever*/
            end      /*i*/
call tsort
say '═══compile order═══'
@=  'libraries found.)'
#=0;                             do o=nO  by -1  for nO;  #= #+1;  say word(label, iOrd.o)
                                 end   /*o*/;             if #==0  then #= 'no'
say '   ('#   @;        say
say '═══unordered libraries═══'
#=0;                             do u=nO+1  to nL;        #= #+1;  say word(label, iOrd.u)
                                 end   /*u*/;             if #==0  then #= 'no'
say '   ('#   "unordered"  @
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
tSort: procedure expose iDep. iOrd. iPos. nd nL nO
                                  do i=1  for nL;  iOrd.i=i;   iPos.i=i
                                  end   /*i*/
       k=1
                                  do  until k<=j;              j=k
                                  k=nL + 1
                                      do i=1  for nd
                                      iL =iDep.i.1      ;      iR =iPos.iL
                                      ipL=iPos.iL       ;      ipR=iPos.iR
                                      if iL==iR | ipL>.k | ipL<j | ipR<j  then iterate
                                      k=k - 1
                                      _=iOrd.k          ;      iPos._ =ipL
                                                               iPos.iL=k
                                      iOrd.ipL=iOrd.k   ;      iOrd.k =iL
                                      end   /*i*/
                                  end       /*until*/
       nO=j - 1;   return

/*REXX pgm does a topological sort (orders such that no item precedes a dependent item).*/
idep.=0;   ipos.=0;  iord.=0                     /*initialize some stemmed arrays to  0.*/
label= 'DES_SYSTEM_LIB DW01 DW02 DW03 DW04 DW05 DW06 DW07 DWARE GTECH RAMLIB',
       'STD_CELL_LIB SYNOPSYS STD IEEE'

icode=1 14 13 12 1 3 2 11 15 0 2 15 2 9 10 0 3 15 3 9 0 4 14 213 9 4 3 2 15 10 0 5 5 15 2,
      9 10 0 6 6 15 9 0 7 7 15 9 0 8 15 9 0 39 15 9 0 10 15 10 0 11 14 15 0 12 15 12 0 0

idep.=0;   ipos.=0;  iord.=0                     /*initialize some stemmed arrays to  0.*/
nl=15;  nd=44;  nc=69;  j=0;  i=0                /*     "       "  "parms"  and indices.*/

10:    i=i+1
       il=word(icode, i)
       if il==0  then signal 30
20:    i=i+1
       ir=word(icode, i)
       if ir==0  then signal 10
       j=j+1
       idep.j.1=il
       idep.j.2=ir
       signal 20
30:    call tsort
       say '═══compile order═══'
       q=0;                             do o=no  by -1  for no;     q=q+1
                                        say word(label, iord.o)
                                        end  /*o*/
       if q==0  then q='no'
       say '   ('q "libraries found.)"
       say
       say '═══unordered libraries═══'
       q=0;                             do u=no+1  to nl;           q=q+1
                                        say word(label, iord.u)
                                        end  /*u*/
       if q==0  then q='no'
       say '   ('q "unordered libraries found.)"
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
tSort: procedure expose nl nd idep. iord. ipos. no
                      do i=1  for nl
                      iord.i=i
                      ipos.i=i
                      end   /*i*/
       k=1
                      do forever
                      j=k
                      k=nl+1
                                 do i=1  for nd
                                 il=idep.i.1
                                 ir=ipos.il
                                 ipl=ipos.il
                                 ipr=ipos.ir
                                 if il==ir | ipl>.k | ipl<j | ipr<j  then iterate
                                 k=k-1
                                 _=iord.k;  ipos._=ipl
                                 ipos.il=k
                                 iord.ipl=iord.k
                                 iord.k=il
                                 end   /*i*/
                      if k<=j  then leave
                      end   /*forever*/
       no=j-1
       return

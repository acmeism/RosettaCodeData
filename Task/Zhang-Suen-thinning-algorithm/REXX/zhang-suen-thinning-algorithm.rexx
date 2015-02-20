/*REXX pgm thins a NxM char grid using the Zhang-Suen thinning algorithm*/
parse arg iFID .;  if iFID==''  then iFID='ZHANG_SUEN.DAT'
white=' ';         @.=white            /* [↓] read the input char grid. */
           do row=1  while lines(iFID)\==0;  _=linein(iFID)
           _=translate(_,,.0);               cols.row=length(_)
               do col=1  for cols.row;  @.row.col=substr(_,col,1)
               end   /*col*/           /* [↑]  assign whole row of chars*/
           end       /*row*/
rows=row-1                             /* adjust ROWS because of DO loop*/
call show@ 'input file ' iFID  " contents:"  /*show the input char grid.*/

  do  until  changed==0;    changed=0  /*keep slimming until we're done.*/
       do step=1  for 2                /*keep track of  step 1 │ step 2.*/
         do     r=1  for rows          /*process all  rows and columns. */
             do c=1  for cols.r;  !.r.c=@.r.c   /*assign alternate grid.*/
             if r==1|r==rows|c==1|c==cols.r  then iterate  /*is an edge?*/
             if @.r.c==white  then iterate      /*White?   Then skip it.*/
             call Ps;  b=b()                    /*define  Ps  and "b".  */
             if b<2 | b>6  then iterate         /*is   B   within range?*/
             if a()\==1    then iterate         /*count the transitions.*/        /*  ╔══╦══╦══╗  */
             if step==1 then if (p2 & p4 & p6) | p4 & p6 & p8 then iterate        /*  ║p9║p2║p3║  */
             if step==2 then if (p2 & p4 & p8) | p2 & p6 & p8 then iterate        /*  ╠══╬══╬══╣  */
             !.r.c=white               /*set a grid character to  white.*/        /*  ║p8║p1║p4║  */
             changed=1                 /*indicate a char was changed.   */        /*  ╠══╬══╬══╣  */
             end   /*c*/                                                          /*  ║p7║p6║p5║  */
         end       /*r*/                                                          /*  ╚══╩══╩══╝  */
       call copy!2@                    /*copy alternate to working grid.*/
       end         /*step*/
  end              /*until changed==0*/

call show@ 'slimmed output:'           /*display the slimmed char grid. */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────subroutines─────────────────────────*/
a: return (\p2==p3&p3)+(\p3==p4&p4)+(\p4==p5&p5)+(\p5==p6&p6)+(\p6==p7&p7)+(\p7==p8&p8)+(\p8==p9&p9)+(\p9==p2&p2)
b: return p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9
copy!2@:  do r=1 for rows; do c=1 for cols.r; @.r.c=!.r.c; end;end; return
show@: say; say arg(1); say; do r=1 for rows; _=; do c=1 for cols.r; _=_||@.r.c; end; say _; end; return

Ps:  rm=r-1;  rp=r+1;  cm=c-1;  cp=c+1            /*calculate shortcuts.*/
     p2=@.rm.c\==white; p3=@.rm.cp\==white; p4=@.r.cp\==white; p5=@.rp.cp\==white
     p6=@.rp.c\==white; p7=@.rp.cm\==white; p8=@.r.cm\==white; p9=@.rm.cm\==white; return

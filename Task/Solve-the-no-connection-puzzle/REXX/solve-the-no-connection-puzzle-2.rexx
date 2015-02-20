/*REXX program solves the  "no-connection"  puzzle  (with eight pegs).  */
@abc='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
parse arg limit .     /*# solutions*/  /* ╔═══════════════════════════╗ */
if limit==''  then limit=1             /* ║          A    B           ║ */
oLimit=limit;      limit=abs(limit)    /* ║         /│\  /│\          ║ */
@.  =                                  /* ║        / │ \/ │ \         ║ */
@.1 = 'A   C D E'                      /* ║       /  │ /\ │  \        ║ */
@.2 = 'B   D E F'                      /* ║      /   │/  \│   \       ║ */
@.3 = 'C   A D G'                      /* ║     C────D────E────F      ║ */
@.4 = 'D   A B C E G'                  /* ║      \   │\  /│   /       ║ */
@.5 = 'E   A B D F H'                  /* ║       \  │ \/ │  /        ║ */
@.6 = 'F   B E G'                      /* ║        \ │ /\ │ /         ║ */
@.7 = 'G   C D E'                      /* ║         \│/  \│/          ║ */
@.8 = 'H   D E F'                      /* ║          G    H           ║ */
cnt=0                                  /* ╚═══════════════════════════╝ */
                   do nodes=1  while  @.nodes\=='';    _=word(@.nodes,1)
                   subs=0              /* [↓]  create list of node paths*/
                              do #=1  for  words(@.nodes)-1
                              __=word(@.nodes,#+1);  if __>_  then iterate
                              subs=subs+1;           !._.subs=__
                              end  /*#*/
                   !._.0=subs          /*assign the number of node paths*/
                   end   /*nodes*/
pegs=nodes-1                           /*number of pegs to be seated.   */
             do a=1  for pegs;               if ?('A')  then iterate
              do b=1  for pegs;              if ?('B')  then iterate
               do c=1  for pegs;             if ?('C')  then iterate
                do d=1  for pegs;            if ?('D')  then iterate
                 do e=1  for pegs;           if ?('E')  then iterate
                  do f=1  for pegs;          if ?('F')  then iterate
                   do g=1  for pegs;         if ?('G')  then iterate
                    do h=1  for pegs;        if ?('H')  then iterate
                    call showNodes
                    cnt=cnt+1;         if cnt==limit  then leave a
                    end   /*h*/
                   end    /*g*/
                  end     /*f*/
                 end      /*e*/
                end       /*d*/
               end        /*c*/
              end         /*b*/
             end          /*a*/
say                                    /*display a blank line to screen.*/
s=left('s',cnt\==1)                    /*handle case of plurals (or not)*/
say 'found '   cnt   " solution"s'.'   /*display the number of solutions*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────? subroutine────────────────────────*/
?:  parse arg node;     nn=value(node);     nL=nn-1;     nH=nn+1
  do cn=c2d('A')  to c2d(node)-1; if value(d2c(cn))==nn then return 1; end
                                       /* [↑]  see if any are duplicates*/
     do ch=1  for !.node.0             /* [↓]  see if any  ¬ =  ±1 value*/
     $=!.node.ch;  fn=value($)         /*node name and its current peg#.*/
     if nL==fn | nH==fn  then return 1 /*if ≡ ±1, then it can't be used.*/
     end   /*ch*/                      /* [↑]  looking for suitable num.*/
return 0                               /*the sub arg value passed is OK.*/
/*──────────────────────────────────SHOWNODES subroutine────────────────*/
showNodes: _='     '                   /*_   is used for padding output.*/
show=0                                 /*indicates graph not found yet. */

  do box=1  for sourceline()  while oLimit<0   /*Negative?  Then show it*/
  xw=sourceline(box)                   /*get a line of this REXX program*/
  p2=lastpos('*',xw)                   /*position of    last   asterisk.*/
  p1=lastpos('*',xw,max(1,p2-1))       /*    "    " penultimate    "    */
  if pos('╔', xw)\==0  then show=1     /*Found the top-left box corner? */
  if \show             then iterate    /*Not found?  Then skip this line*/
  xb=substr(xw, p1+1, p2-p1-2)         /*extract the "box" part of line.*/
  xt=xb                                /*get a working copy of the box. */
        do jx=1  for pegs              /*do a substitution for all pegs.*/
        aa=substr(@abc,jx,1)           /*get the name of the peg (A──►Z)*/
        xt=translate(xt,value(aa),aa)  /*substitute peg name with value.*/
        end    /*jx*/                  /* [↑]  graph limited to 26 nodes*/
  say _ xb _ _ xt                      /*display one line of the graph. */
  if pos('╝',xw)\==0  then return      /*Last line of graph?  Then stop.*/
  end   /*box*/
                                       /* [↓]   show a simple solution. */
say _ 'a='a _ 'b='||b _ 'c='c _ 'd='d _ 'e='e _ 'f='f _ 'g='g _ 'h='h

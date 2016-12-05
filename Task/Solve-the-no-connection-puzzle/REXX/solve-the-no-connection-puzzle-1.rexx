/*REXX program  solves  the  "no-connection"  puzzle   (the puzzle has eight pegs).     */
parse arg limit .    /*number of solutions wanted.*/   /* ╔═══════════════════════════╗ */
if limit=='' | limit=="."  then limit=1                /* ║          A    B           ║ */
                                                       /* ║         /│\  /│\          ║ */
@.  =                                                  /* ║        / │ \/ │ \         ║ */
@.1 = 'A   C D E'                                      /* ║       /  │ /\ │  \        ║ */
@.2 = 'B   D E F'                                      /* ║      /   │/  \│   \       ║ */
@.3 = 'C   A D G'                                      /* ║     C────D────E────F      ║ */
@.4 = 'D   A B C E G'                                  /* ║      \   │\  /│   /       ║ */
@.5 = 'E   A B D F H'                                  /* ║       \  │ \/ │  /        ║ */
@.6 = 'F   B E G'                                      /* ║        \ │ /\ │ /         ║ */
@.7 = 'G   C D E'                                      /* ║         \│/  \│/          ║ */
@.8 = 'H   D E F'                                      /* ║          G    H           ║ */
cnt=0                                                  /* ╚═══════════════════════════╝ */
                  do nodes=1  while  @.nodes\=='';    _=word(@.nodes,1)
                  subs=0
                             do #=1  for  words(@.nodes)-1  /*create list of node paths.*/
                             __=word(@.nodes,#+1);   if __>_  then iterate
                             subs=subs + 1;          !._.subs=__
                             end  /*#*/
                  !._.0=subs                     /*assign the number of the node paths. */
                  end   /*nodes*/
pegs=nodes-1                                     /*the number of pegs to be seated.     */
_='    '                                         /*_   is used for indenting the output.*/
        do        a=1  for pegs;     if ?('A')  then iterate
         do       b=1  for pegs;     if ?('B')  then iterate
          do      c=1  for pegs;     if ?('C')  then iterate
           do     d=1  for pegs;     if ?('D')  then iterate
            do    e=1  for pegs;     if ?('E')  then iterate
             do   f=1  for pegs;     if ?('F')  then iterate
              do  g=1  for pegs;     if ?('G')  then iterate
               do h=1  for pegs;     if ?('H')  then iterate
               say _ 'a='a _  'b='||b _  'c='c _  'd='d _  'e='e _  'f='f _  'g='g _ 'h='h
               cnt=cnt+1;        if cnt==limit  then leave a
               end   /*h*/
              end    /*g*/
             end     /*f*/
            end      /*e*/
           end       /*d*/
          end        /*c*/
         end         /*b*/
        end          /*a*/
say                                              /*display a blank line to the terminal.*/
s=left('s',cnt\==1)                              /*handle the case of plurals  (or not).*/
say 'found '   cnt   " solution"s'.'             /*display the number of solutions found*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
?: parse arg node;  nn=value(node)
   nH=nn+1
             do cn=c2d('A')  to c2d(node)-1;  if value( d2c(cn) )==nn  then return 1
             end   /*cn*/                       /* [↑]  see if there any are duplicates.*/
   nL=nn-1
             do ch=1  for !.node.0              /* [↓]  see if there any  ¬= ±1  values.*/
             $=!.node.ch;        fn=value($)    /*the node name  and  its current peg #.*/
             if nL==fn | nH==fn  then return 1  /*if ≡ ±1,  then the node can't be used.*/
             end   /*ch*/                       /* [↑]  looking for suitable number.    */
   return 0                                     /*the subroutine arg value passed is OK.*/

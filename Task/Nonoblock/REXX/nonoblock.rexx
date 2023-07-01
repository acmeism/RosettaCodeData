/*REXX program enumerates all possible configurations (or an error) for nonogram puzzles*/
             $.=;    $.1=  5   2 1
                     $.2=  5
                     $.3= 10   8
                     $.4= 15   2 3 2 3
                     $.5=  5   2 3
      do  i=1  while $.i\==''
      parse var  $.i   N  blocks                 /*obtain  N  and  blocks   from array. */
      N= strip(N);     blocks= space(blocks)     /*assign stripped   N   and   blocks.  */
      call nono                                  /*incoke NONO subroutine for heavy work*/
      end   /*i*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
nono: say copies('=', 70)                                 /*display seperator for title.*/
      say 'For '   N   " cells  and blocks of: "   blocks /*display the title for output*/
      z=                                                  /*assign starter value for Z. */
          do w=1  for words(blocks)                       /*process each of the blocks. */
          z= z copies('#', word(blocks,w) )               /*build a string for 1st value*/
          end   /*w*/                                     /*Z  now has a leading blank. */
      #= 1                                                /*number of positions (so far)*/
      z= translate( strip(z), ., ' ');   L= length(z)     /*change blanks to periods.   */
      if L>N  then do;   say '***error***  invalid blocks for number of cells.';   return
                   end
      @.0=;           @.1= z;         !.=0       /*assign default and the first position*/
      z= pad(z)                                  /*fill─out (pad) the value with periods*/

         do prepend=1  while words(blocks)\==0   /*process all the positions (leading .)*/
         new= . || @.prepend                     /*create positions with leading dots.  */
         if length(new)>N  then leave            /*Length is too long?  Then stop adding*/
         call add                                /*add position that has a leading dot. */
         end   /*prepend*/                       /* [↑]  prepend positions with dots.   */

         do   k=1  for N                         /*process each of the positions so far.*/
           do c=1  for N                         /*   "      "   "  "  position blocks. */
           if @.c==''  then iterate              /*if string is null,  skip the string. */
           p= loc(@.c, k)                        /*find location of block in position.  */
           if p==0 | p>=N  then iterate          /*Location zero or out─of─range?  Skip.*/
           new= strip( insert(., @.c, p),'T',.)  /*insert a dot and strip trailing dots.*/
           if strip(new,'T',.)=@.c  then iterate /*Is it the same value?  Then skip it. */
           if length(new)<=N  then call add      /*Is length OK?   Then add position.   */
           end   /*k*/
         end     /*c*/
      say
      say '─position─'  center("value", max(7, length(z) ), '─')  /*show hdr for output.*/

               do m=1  for #
               say center(m, 10)   pad(@.m)      /*display the index count and position.*/
               end   /*m*/
      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
loc:  _=0; do arg(2); _=pos('#.',pad(arg(1)),_+1); if _==0  then return 0; end; return _+1
add:  if !.new==1  then return;  #= # + 1;     @.#= new;    !.new=1;    return
pad:  return  left( arg(1), N, .)

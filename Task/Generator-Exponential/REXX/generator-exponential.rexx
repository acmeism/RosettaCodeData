/*REXX program to show how to use a generator (also known as iterators).*/
numeric digits 10000                   /*just in case we need big 'uns. */
parse arg show;           show = word(show 0, 1)       /*show this many.*/
@gen.=                                 /*generators start from scratch. */
         do j=1  to show;  call tell 'squares' ,gen_squares(j)  ;   end
         do j=1  to show;  call tell 'cubes'   ,gen_cubes(j)    ;   end
         do j=1  to show;  call tell 'sq¬cubes',gen_sqNcubes(j) ;   end
                if show>0  then say 'dropping 1st ──► 20th values.'
         do j=1  to 20;        drop @gen.sqNcubes.j                 ;  end
         do j=20+1  for 10  ;  call tell 'sq¬cubes',gen_sqNcubes(j) ;  end
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────gen_powers iterator──────────────*/
gen_powers:  procedure expose @gen.;  parse arg x,p; if x==''  then return
if @gen.powers.x.p==''  then @gen.powers.x.p=x**p;  return @gen.powers.x.p
/*─────────────────────────────────────gen_squares iterator─────────────*/
gen_squares: procedure expose @gen.;  parse arg x;   if x==''  then return
if @gen.squares.x==''   then do;   call gen_powers x,2
                                   @gen.squares.x=@gen.powers.x.2
                             end
return @gen.squares.x
/*─────────────────────────────────────gen_cubes iterator───────────────*/
gen_cubes: procedure expose @gen.;    parse arg x;   if x==''  then return
if @gen.cubes.j==''     then do;   call gen_powers x,3
                                   @gen.cubes.x=@gen.powers.x.3
                             end
return @gen.cubes.x
/*─────────────────────────────────────gen_squares not cubes iterator───*/
gen_sqNcubes: procedure expose @gen.; parse arg x;   if x==''  then return
s=0
if @gen.sqNcubes.x=='' then do j=1  to x
                            if @gen.sqNcubes\=='' then do;  sq=sq+1
                                                            iterate
                                                       end
                                  do s=s+1  /*slow way to weed out cubes*/
                                  ?=gen_squares(s)
                                         do c=1  until gen_cubes(c)>?
                                         if gen_cubes(c)==? then iterate s
                                         end   /*c*/
                                  leave
                                  end          /*s*/
                            @gen.sqNcubes.x=?
                            @gen.sqNcubes.x=@gen.squares.s
                            end                /*j*/
return @gen.sqNcubes.x
/*──────────────────────────────────TELL subroutine─────────────────────*/
tell: if j==1  then say                /* [↓] format args to be aligned.*/
               say  right(arg(1),20)  right(j,5)  right(arg(2),20); return

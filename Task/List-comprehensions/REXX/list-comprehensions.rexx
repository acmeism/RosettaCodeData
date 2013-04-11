/*REXX program to list  Pythagorean triples  up to a specified number.  */
parse arg n .                          /*get the argument (possibly).   */
if n=='' then n=100                    /*Not specified?  Then assume 100*/
call gen_triples n                     /*generate Pythagorean triples.  */
call showhdr                           /*show a nice header.            */
call showlist triples                  /*show the Pythagorean triples.  */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────GEN_TRIPLES subroutine──────────────*/
gen_triples: parse arg lim             /*generate Pythorgorean triples. */
triples=

      do a=1  for lim-2;     aa=a*a    /*a*a    is faster than    a**2  */
        do b=a+1  to lim-1;  aabb=aa+b*b
          do c=b+1 to lim
          if aabb==c*c  then triples=triples '['a"-" || b'-'c"]"
          end   /*c*/
        end     /*b*/
      end       /*a*/

triples=strip(triples)
return
/*──────────────────────────────────SHOWHDR subroutine──────────────────*/
showHdr: say
if 'f0'x==0 then do; super2='b2'x; le='8c'x; end   /*EBCDIC: super2, LE */
            else do; super2='fd'x; le='f3'x; end   /* ASCII:   "     "  */
note='(a'super2 "+ b"super2 '= c'super2",  c "le n')'  /*prettify equat.*/
say 'Pythagorean triples' note":"
return
/*──────────────────────────────────SHOWLIST subroutine─────────────────*/
showlist: procedure; parse arg L       /*get the list  (L).             */
w=words(L)                             /*number of members in the list. */
say;          do j=1  for w            /*display the members of the list*/
              say word(L,j)
              end   /*j*/
say;  say w 'members listed.'
return

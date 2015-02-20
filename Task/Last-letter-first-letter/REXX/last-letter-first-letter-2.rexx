/*REXX pgm to find longest path of word's last-letter ──► to 1st-letter.*/
@='audino bagon baltoy banette bidoof braviary bronzor carracosta charmeleon cresselia croagunk darmanitan',
  'deino emboar emolga exeggcute gabite girafarig gulpin haxorus heatmor heatran ivysaur jellicent',
  'jumpluff kangaskhan kricketune landorus ledyba loudred lumineon lunatone machamp magnezone mamoswine',
  'nosepass petilil pidgeotto pikachu pinsir poliwrath poochyena porygon2 porygonz registeel relicanth',
  'remoraid rufflet sableye scolipede scrafty seaking sealeo silcoon simisear snivy snorlax spoink',
  'starly tirtouga trapinch treecko tyrogue vigoroth vulpix wailord wartortle whismur wingull yamask'
#=words(@)
parse arg limit .;  if limit\=='' then #=limit     /*allow a scan limit.*/
@.=;  $$$=;  ig=0                      /*nullify array and longest path.*/
call build@.                           /*build a stemmed array from list*/
               do v=#  by -1  for #    /*scrub list for unusuable words.*/
               F= left(@.v,1)          /*first letter of the word.      */
               L=right(@.v,1)          /* last    "    "  "    "        */
               if !.1.F>1 | !.9.L>1  then iterate      /*is a dead word?*/
               @=delword(@,v,1)                        /*delete from @. */
               say 'ignorning dead word:' @.v;  ig=ig+1
               end   /*v*/

if ig\==0 then do
               call build@.
               say;     say 'ignoring' ig "dead word"s(ig)'.';     say
               end
soFar=0                                /*the initial maximum path length*/
               do j=1  for #
               parse  value  @.1 @.j   with   @.j @.1
               call scanner $$$,2
               parse  value  @.1 @.j   with   @.j @.1
               end   /*j*/
g=words($$$)
say 'Of' # "words," MP 'path's(MP) "have the maximum path length of"  g'.'
say;                         say 'One example path of that length is:'
      do m=1  for g                    /*display a list of words to term*/
      say left('',39) word($$$,m)
      end   /*m*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────BUILD suroutine─────────────────────*/
build@.:  !.=0;     do i=1  for #      /*build a stemmed array from list*/
                    @.i=word(@,i)
                    F= left(@.i,1);   !.1.F=!.1.F+1   /*count  1st chars*/
                    L=right(@.i,1);   !.9.L=!.9.L+1   /*count last chars*/
                    end   /*i*/
return
/*──────────────────────────────────S subroutine────────────────────────*/
s: if arg(1)==1  then return arg(3);        return word(arg(2) 's',1)
/*──────────────────────────────────SCANNER subroutine (recursive)──────*/
scanner:  procedure expose @. MP # !. soFar $$$;  parse arg $$$,!;   _=!-1
lastChar=right(@._,1)                  /*last char of penultimate word. */
if !.1.lastchar==0  then return        /*is this a dead-end word?       */

  do i=!  to #                         /*scan for the longest word path.*/
  if left(@.i,1)==lastChar then        /*is the first-char = last-char? */
    do
    if !==soFar then MP=MP+1           /*bump the maximum paths counter.*/
                else if !>soFar  then do;  $$$=@.1          /*rebuild it*/
                                                   do n=2  to !-1
                                                   $$$=$$$ @.n
                                                   end   /*n*/
                                      $$$=$$$ @.i            /*add last. */
                                      MP=1;   soFar=!        /*new path. */
                                      end
    parse value @.! @.i  with  @.i @.!
    call scanner $$$,!+1               /*recursive scan for longest path*/
    parse value @.! @.i  with  @.i @.!
    end
  end    /*i*/

return                                 /*exhausted this particular scan.*/

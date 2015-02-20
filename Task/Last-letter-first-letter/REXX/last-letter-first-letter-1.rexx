/*REXX pgm to find longest path of word's last-letter ──► to 1st-letter.*/
@='audino bagon baltoy banette bidoof braviary bronzor carracosta charmeleon cresselia croagunk darmanitan',
  'deino emboar emolga exeggcute gabite girafarig gulpin haxorus heatmor heatran ivysaur jellicent',
  'jumpluff kangaskhan kricketune landorus ledyba loudred lumineon lunatone machamp magnezone mamoswine',
  'nosepass petilil pidgeotto pikachu pinsir poliwrath poochyena porygon2 porygonz registeel relicanth',
  'remoraid rufflet sableye scolipede scrafty seaking sealeo silcoon simisear snivy snorlax spoink',
  'starly tirtouga trapinch treecko tyrogue vigoroth vulpix wailord wartortle whismur wingull yamask'
#=words(@)
parse arg limit .;  if limit\==''  then #=limit    /*allow a scan limit.*/
@.=;  $$$=                             /*nullify array, and longest path*/
                  do i=1  for #        /*build a stemmed array from list*/
                  @.i=word(@,i)
                  end   /*i*/
soFar=0                                /*the initial maximum path length*/
                  do j=1  for #
                  parse  value  @.1 @.j   with   @.j @.1
                  call scanner $$$,2
                  parse  value  @.1 @.j   with   @.j @.1
                  end   /*j*/
L=words($$$)
say 'Of' # "words," MP 'path's(MP) "have the maximum path length of" L'.'
say;     say 'One example path of that length is:'
      do m=1  for L;     say left('',39) word($$$,m);     end   /*m*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────S subroutine────────────────────────*/
s: if arg(1)==1  then return arg(3);        return word(arg(2) 's',1)
/*──────────────────────────────────SCANNER subroutine (recursive)──────*/
scanner:  procedure expose @. MP # soFar $$$;   parse arg $$$,!;     _=!-1
lastChar=right(@._,1)                  /*last char of penultimate word. */

  do i=!  to #                         /*scan for the longest word path.*/
  if left(@.i,1)==lastChar then        /*is the first-char = last-char? */
    do
    if !==soFar  then MP=MP+1          /*bump the maximum paths counter.*/
                 else if !>soFar  then do; $$$=@.1            /*rebuild.*/
                                                   do n=2  to !-1
                                                   $$$=$$$ @.n
                                                   end  /*n*/
                                       $$$=$$$ @.i            /*add last*/
                                       MP=1;  soFar=!         /*new path*/
                                       end
    parse value @.! @.i  with  @.i @.!
    call scanner $$$, !+1              /*recursive scan for longest path*/
    parse value @.! @.i  with  @.i @.!
    end
  end    /*i*/
return                                 /*exhausted this particular scan.*/

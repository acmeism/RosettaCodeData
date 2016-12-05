/*REXX program finds the  longest path of word's   last─letter ───► first-letter.       */
@='audino bagon baltoy banette bidoof braviary bronzor carracosta charmeleon cresselia croagunk darmanitan',
  'deino emboar emolga exeggcute gabite girafarig gulpin haxorus heatmor heatran ivysaur jellicent',
  'jumpluff kangaskhan kricketune landorus ledyba loudred lumineon lunatone machamp magnezone mamoswine',
  'nosepass petilil pidgeotto pikachu pinsir poliwrath poochyena porygon2 porygonz registeel relicanth',
  'remoraid rufflet sableye scolipede scrafty seaking sealeo silcoon simisear snivy snorlax spoink',
  'starly tirtouga trapinch treecko tyrogue vigoroth vulpix wailord wartortle whismur wingull yamask'
#=words(@)
parse arg limit .;  if limit\==''  then #=limit  /*allow user to specify a scan limit.  */
@.=;  $$$=                                       /*nullify array; and also longest path.*/
                  do i=1  for #                  /*build a stemmed array from the list. */
                  @.i=word(@, i)
                  end   /*i*/
MP=0;  MPL=0                                     /*the initial   Maximum Path Length.   */
                  do j=1  for #                  /*              ─       ─    ─         */
                  parse  value  @.1 @.j   with   @.j @.1;  call scan $$$, 2
                  parse  value  @.1 @.j   with   @.j @.1
                  end   /*j*/
g=words($$$)
say 'Of'    #    "words,"    MP    'path's(MP)    "have the maximum path length of"   g'.'
say;     say 'One example path of that length is:'
                     do m=1  for g;     say left('', 39)  word($$$, m);        end   /*m*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
s: if arg(1)==1  then return arg(3);         return word(arg(2) 's', 1)
/*──────────────────────────────────────────────────────────────────────────────────────*/
scan: procedure expose @. MP # MPL $$$;   parse arg $$$,!;                _=!-1
      parse var  @._  ''  -1  LC                 /*obtain the last character of prev. @ */
                                                 /* [↓]  PARSE obtains first char of @.i*/
          do i=!  to #;  parse var  @.i  _  2    /* [↓]  scan for the longest word path.*/
          if _==LC  then do                      /*is the  first-char  =  last-char?    */
                         if !==MPL  then MP=MP+1 /*bump the  Maximum Paths  counter.    */
                                    else if !>MPL  then do; $$$=@.1          /*rebuild. */
                                                               do n=2  to !-1; $$$=$$$ @.n
                                                               end  /*n*/
                                                            $$$=$$$  @.i     /*add last.*/
                                                            MP=1;    MPL=!   /*new path.*/
                                                        end
                         parse value @.! @.i  with  @.i @.!;         call scan $$$, !+1
                         parse value @.! @.i  with  @.i @.!
                         end   /*if─then*/
          end   /*i*/
      return                                     /*exhausted this particular scan.      */

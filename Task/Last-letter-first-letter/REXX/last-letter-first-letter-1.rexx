/*REXX program finds the  longest path of word's   last─letter ───► first─letter.       */
@='audino bagon baltoy banette bidoof braviary bronzor carracosta charmeleon cresselia croagunk darmanitan',
  'deino emboar emolga exeggcute gabite girafarig gulpin haxorus heatmor heatran ivysaur jellicent',
  'jumpluff kangaskhan kricketune landorus ledyba loudred lumineon lunatone machamp magnezone mamoswine',
  'nosepass petilil pidgeotto pikachu pinsir poliwrath poochyena porygon2 porygonz registeel relicanth',
  'remoraid rufflet sableye scolipede scrafty seaking sealeo silcoon simisear snivy snorlax spoink',
  'starly tirtouga trapinch treecko tyrogue vigoroth vulpix wailord wartortle whismur wingull yamask'
#= words(@);        ig= 0;   !.= 0;    @.=       /*nullify array and the longest path.  */
parse arg limit .;  if limit\==''  then #=limit  /*allow user to specify a scan limit.  */
call build@                                      /*build a stemmed array from the @ list*/
                do v=#  by -1  for #             /*scrub the @ list for unusable words. */
                parse var @.v  F  2  ''  -1  L   /*obtain first and last letter of word.*/
                if !.1.F>1  |  !.9.L>1  then iterate              /*is this a dead word?*/
                say 'ignoring dead word:'   @.v;      ig= ig + 1;      @= delword(@, v, 1)
                end   /*v*/                      /*delete dead word from  @ ──┘         */
$$$=                                             /*nullify the possible longest path.   */
if ig\==0  then do;   call build@;   say;   say 'ignoring'   ig   "dead word"s(ig).;   say
                end
MP= 0;  MPL= 0                                   /*the initial   Maximum Path Length.   */
                do j=1  for #                    /*              ─       ─    ─         */
                parse  value  @.1 @.j   with   @.j @.1;          call scan $$$, 2
                parse  value  @.1 @.j   with   @.j @.1
                end   /*j*/
g= words($$$)
say 'Of'    #    "words,"    MP    'path's(MP)    "have the maximum path length of"   g'.'
say;     say 'One example path of that length is: '     word($$$, 1)
                do m=2  to g;      say left('', 36)     word($$$, m)
                end   /**/
exit 0                                            /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
s:    if arg(1)==1  then return arg(3);    return word( arg(2) 's', 1)   /*a pluralizer.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
build@:     do i=1  for #;     @.i=word(@, i)    /*build a stemmed array from the list. */
            F= left(@.i, 1);   !.1.F= !.1.F + 1  /*F:  1st char; !.1.F=count of 1st char*/
            L=right(@.i, 1);   !.9.L= !.9.L + 1  /*L: last   "   !.9.L=  "    " last  " */
            end   /*i*/;       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
scan: procedure expose @. # !. $$$ MP MPL;    parse arg $$$,!;                  p=! - 1
      parse var  @.p  ''  -1  LC                 /*obtain last character of previous @. */
      if !.1.LC==0  then return                  /*is this a  dead─end  word?           */
                                                 /* [↓]  PARSE obtains first char of @.i*/
         do i=!  to #;  parse var  @.i  p  2     /*scan for the longest word path.      */
         if p==LC  then do                       /*is the  first─character ≡ last─char? */
                        if !==MPL  then MP= MP+1 /*bump the  Maximum Paths  Counter.    */
                                   else if !>MPL  then do; $$$=@.1           /*rebuild. */
                                                             do n=2  for !-2;  $$$=$$$ @.n
                                                             end   /*n*/
                                                           $$$=$$$   @.i     /*add last.*/
                                                           MP=1;   MPL=!     /*new path.*/
                                                       end
                        parse value  @.! @.i   with   @.i @.!;          call scan $$$, !+1
                        parse value  @.! @.i   with   @.i @.!
                        end
         end    /*i*/;             return        /*exhausted this particular scan.      */

/*REXX program plays Morpion solitaire (with grid output), the default is the 5T version*/
signal on syntax;     signal on noValue          /*handle possible REXX program errors. */
                                                 /* [↓] handle the user options (if any)*/
prompt=                                          /*null string is used for  ERR  return.*/
quiet= 0                                         /*flag:  suppresses output temporarily.*/
oFID= 'MORPION'                                  /*filename of the game's output file.  */
arg game player seed .                           /*see if a person wants to play.       */
if game=='' | game==","  then game= '5T'         /*Not specified?  Then use the default.*/
if player=='' | player==","  then player=        /* "       "        "   "   "     "    */
if isInt(seed)           then call random ,,seed /*Is integer?  Then use for RANDOM seed*/
TorD= 'T (touching) ───or─── D (disjoint).'      /*the valid game types  (T  or  D).    */
sw= linesize() - 1                               /*SW = screen width   ─or─   linesize. */
gT= right(game, 1)                               /*T = touching    ─or─    D = disjoint.*/
if \datatype(gT,'U') | verify(gT, "GT")\==0  then call err 'game not  G  or  T' /*error?*/
gS= left( game, length(game) - 1)                /*gS=Game Size  (line length for a win)*/
if \isInt(gS)  then call err  "game size isn't an integer:"  gS                 /*error?*/
gS= gS / 1                                       /*normalize the value of  GS.          */
if gS<3  then call err  "grid size is too small for Morpion solitaire :"   gS  /*error? */
                                                 /*handle the defaults/configuration.   */
indent= left('', max(0, sw - gS - 10) % 2)       /*indentation used for board display.  */
indent= '  '
empty= 'fa'x                                     /*the empty grid point symbol (glyph). */
@.= empty                                        /*the field  (grid) is infinite in size*/
CBLF= player \== ''                              /*playing with a carbon─based lifeform?*/
if CBLF  then oFID= player                       /*oFID:   the fileID for the game LOG. */
oFID= oFID'.LOG'                                 /*full name for the  LOG's  filename.  */
prompt= 'enter  X,Y  point and an optional character for placing on board   (or Quit):'
prompt= right(prompt, sw, '─')                   /*right justify the prompt message.    */
call GreekX                                      /*draw the  (initial)  Greek cross.    */

  do #=1  for 1500                               /*───play a game of Morpion solitaire. */
  if CBLF  then do
                if Gshots\==''  then do;    parse var Gshots shot Gshots
                                            parse var        shot          gx ',' gy
                                            call mark gx,gy
                                            iterate
                                     end
                if Gshots==''  then leave   /*#*/
                call t prompt;       pull stuff;      stuff= translate(stuff, , ',')
                stuff= space(stuff);                  parse var   stuff    px  py  p
                _= px;    upper _;   if abbrev('QUIT', _, 1)   then exit    /*quitting? */
                if stuff==''  then do;    call display;     iterate
                                   end
                call mark px,py,p
                end   /*if CBLF*/
           else do;         quiet= 1;         shot= translate( word(Gshots, turn), , ',')
                if shot=='' then do 50
                                 xr= loX -1 + random(0, hiX - loX + 2)
                                 yr= loY -1 + random(0, hiY - loY + 2)
                                 if @.xr.yr\==empty    then iterate
                                 if \neighbor(xr, yr)  then iterate
                                 shot= xr yr
                                 end   /*50*/
                call mark word(shot, 1),  word(shot, 2)
                end   /*else*/
   end   /*#*/

call display
call t  '* number of wins ='  wins
exit wins                                        /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Gshot:   if arg()==2  then Gshots= space(Gshots arg(1)','arg(2) );      return
isInt:   return  datatype( arg(1), 'W')                                       /*is int? */
isNum:   return  datatype( arg(1), 'N')                                       /*is num? */
t:       say arg(1);               call lineout oFID,arg(1);            return
/*──────────────────────────────────────────────────────────────────────────────────────*/
?win:    arg z;   L= length(z)
         if L>gS  then do;   if gT=='D'  then return 0        /*longlines ¬ kosker for D*/
                             parse var   z    z1  '?'  z2     /*could be   xxxxx?xxxx   */
                             return length(z1)>=4  |  length(z2)>=4
                       end
         return L==gS
/*──────────────────────────────────────────────────────────────────────────────────────*/
display: call t;  do y=hiY  to loY  by -1;  _c=               /*start at a high  Y.     */
                    do x=loX  to hiX;  != @.x.y;  _c= _c || ! /*build an "X" grid line. */
                    end   /*x*/
                  call t indent _c                            /*display a grid line.    */
                  end     /*y*/

         if wins==0  then call t copies('═', sw)
                     else call t right('(above) the board after'  wins  "turns.", sw, '═')
         call t
         return
/*──────────────────────────────────────────────────────────────────────────────────────*/
err:    if \quiet then do;   call t;   call t
                       call t center(' error ', max(40, sw % 2), "*");              call t
                                 do j=1  for arg();  call t arg(j);  call t;  end;  call t
                       end
        if prompt==''  then exit 13;            return
/*──────────────────────────────────────────────────────────────────────────────────────*/
GreekX: wins= 0;      loX= 1;      hiX= 0;      LB= gS - 1            /*Low cross Beam. */
        turn= 1;      loY= 1;      hiY= 0;      HT= 4 + 3*(LB-2)      /*─         ─     */
        Lintel= LB - 2;            Gshots=;     TB= HT - LB + 1       /*Top cross Beam. */
                                   $= '0f'x;    @@.=                  /*─         ─     */
          do y=1  for HT;   ToB= $ || copies($, Lintel) || $          /*ToB: Top Or Bot.*/
          beam= $ || copies($, Lintel)$ || left('', Lintel)$ || copies($, Lintel) || $
            select                                              /*$:  Greek cross glyph*/
            when y==1 | y==HT  then do x=1  for LB;  call place x+LB-1,y,substr(ToB, x, 1)
                                    end
            when y==LB | y==TB then do x=1  for HT; if x>LB  &  x<TB  then iterate
                                            call place x,y,substr(beam, x, 1)
                                    end
            when y>LB  & y<TB  then do x=1   by HT-1   for 2;  call place x,y,$;   end
            otherwise               do x=LB  by TB-LB  for 2;  call place x,y,$;   end
            end   /*select*/
          end     /*y*/

        @abc= 'abcdefghijklmnopqrstuvwxyz';  @chars= '1234567890'translate(@abc) || @abc
        @@.63= '@' ;     @@.64= "æÆα";       @@.67= 'ß'  ;    @@.68= "¢"  ;    @@.69= '^'
        @@.70= 'Σ' ;     @@.71= "ƒ"  ;       @@.72= 'ñÑπ';    @@.75= "σΘφ";    @@.78= '₧'
        @@.79= '$δ';     @@.81= "¥"  ;       @@.82= '#%&*=+\;'
                                       do j=60  to 99;         @chars= @chars || @@.j
                                       end   /*j*/
        @chars= @chars'()[]{}<>«»'                    /*can't contain "empty", ?, blank.*/
        call display
        return
/*──────────────────────────────────────────────────────────────────────────────────────*/
mark: parse arg xx,yy,pointChar                       /*place marker, check for errors. */
      if pointChar==''  then pointChar= word( substr(@chars, turn, 1)  "+",  1)
      xxcyy= xx','yy;   _.1= xx;     _.2= yy

        do j=1  for 2;  XorY= substr('XY', j, 1)      /*make sure X and Y are integers. */
        if _.j==''            then do; call err XorY "wasn't specified."    ;return 0; end
        if \isNum(_.j)  then do;  call err XorY "isn't numeric:" _.j   ;  return 0;   end
        if \isInt(_.j)  then do;  call err XorY "isn't an integer:" _.j;  return 0;   end
        end   /*j*/

      xx= xx / 1;       yy= yy / 1                    /*normalize integers: + 7  or  5.0*/
      if pointChar==empty |,
         pointChar=='?'   then do; call err 'illegal point character:' pointChar; return 0
                               end
      if @.xx.yy\==empty  then do; call err 'point' xxcyy "is already occupied."; return 0
                               end
      if \neighbor(xx,yy) then do; call err "point" xxcyy "is a bad move."      ; return 0
                               end
      call place xx,yy,'?'
      newWins= seeIfWin()
      if newWins==0  then do;      call err 'point' xxcyy "isn't a good move."
                                   @.xx.yy= empty;         return 0
                          end
      call t "move" turn '  ('xx","yy')   with "'pointChar'"'
      wins= wins + newWins;               @.xx.yy= pointChar
      call display;                       turn= turn + 1
      return 1
/*──────────────────────────────────────────────────────────────────────────────────────*/
neighbor:  parse arg a,b;   am= a - 1;     ap= a + 1;            bm= b - 1;      bp= b + 1
           return @.am.b\==empty | @.am.bm\==empty | @.ap.b\==empty | @.am.bp \== empty |,
                  @.a.bm\==empty | @.ap.bm\==empty | @.a.bp\==empty | @.ap.bp\==empty
/*──────────────────────────────────────────────────────────────────────────────────────*/
noValue:   syntax:    prompt=;     quiet= 0
           call err 'REXX program' condition('C') "error",    condition('D'), ,
                    "REXX source statement (line"  sigl"):",  sourceline(sigl)
/*──────────────────────────────────────────────────────────────────────────────────────*/
place:     parse arg xxp,yyp                           /*place a marker (point) on grid.*/
           loX= min(loX, xxp);     hiX= max(hiX, xxp)
           loY= min(loY, yyp);     hiY= max(hiY, yyp);      @.xxp.yyp= arg(3)
           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
seeIfWin:  y=yy;           z= @.xx.yy         /*count horizontal/vertical/diagonal wins.*/
                do x=xx+1;               if @.x.y==empty  then leave;   z= z||@.x.y;   end
                do x=xx-1  by -1;        if @.x.y==empty  then leave;   z= @.x.y||z;   end
           if ?win(z)  then return 1          /*────────count wins in horizontal line.  */
           x= xx;          z= @.xx.yy
                do y=yy+1;               if @.x.y==empty  then leave;   z= z||@.x.y;   end
                do y=yy-1  by -1;        if @.x.y==empty  then leave;   z= @.x.y||z;   end
           if ?win(z)  then return 1          /*────────count wins in vertical line.    */
           x= xx;          z= @.xx.yy
                do y=yy+1;  x= x + 1;    if @.x.y==empty  then leave;   z= z||@.x.y;   end
           x= xx
                do y=yy-1  by -1; x=x-1; if @.x.y==empty  then leave;   z= @.x.y||z;   end
           if ?win(z)  then return 1          /*──────count diag wins: up & >, down & < */
           x= xx;           z= @.xx.yy
                do y=yy+1;  x= x - 1;    if @.x.y==empty  then leave;   z= z||@.x.y;   end
           x= xx
                do y=yy-1  by -1; x=x+1; if @.x.y==empty  then leave;   z= z||@.x.y;   end
           return ?win(z)                     /*──────count diag wins: up & <, down & > */

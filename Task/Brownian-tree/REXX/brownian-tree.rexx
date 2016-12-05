/*REXX program animates and displays Brownian motion of dust in a field (with one seed).*/
parse arg height width motes randSeed .          /*get args from the C.L. */
if height=='' | height==","  then height=0       /*Not specified?  Then use the default.*/
if  width=='' |  width==","  then  width=0       /* "      "         "   "   "      "   */
if  motes=='' |  motes==","  then  motes='10%'   /*The  %  dust motes in the field,     */
                                                 /* [↑]  either a #  -or-  a # with a %.*/
tree     = '*'                                   /*an affixed dust speck, start of tree.*/
mote     = '·'                                   /*character for a loose mote (of dust).*/
hole     = ' '                                   /*    "      "  an empty spot in field.*/
clearScr = 'CLS'                                 /*(DOS)  command to clear the screen.  */
eons     = 1000000                               /*number cycles for  Brownian movement.*/
snapshot = 0                                     /*every   N  winks, display a snapshot.*/
snaptime = 1                                     /*  "     "  secs,     "    "     "    */
seedPos  = 30 45                                 /*place a seed in this field position. */
seedPos  = 0                                     /*if =0,  then use middle of the field.*/
                                                 /* " -1,    "   "   a random placement.*/
                                                 /*otherwise, place the seed at seedPos.*/
                                                 /*use RANDSEED for RANDOM repeatability*/
if datatype(randSeed,'W')  then call random ,,randSeed    /*if an integer, use the seed.*/
                                                 /* [↑]  set the first  random  number. */
if height==0 | width==0 then _=scrsize()         /*Note: not all REXXes have SCRSIZE BIF*/
if height==0            then height=word(_,1)-3  /*adjust useable height for the border.*/
if             width==0 then  width=word(_,2)-1  /*   "      "    width   "   "     "   */

                     seedAt=seedPos
if seedPos== 0  then seedAt=width%2 height%2     /*if it's a zero,  start in the middle.*/
if seedPos==-1  then seedAt=random(1,width) random(1,height)  /*if negative, use random.*/
parse  var  seedAt    xs  ys  .                  /*obtain the  X and Y  seed coördinates*/
                                                 /* [↓]  if right-most ≡ '%', then use %*/
if right(motes,1)=='%'  then motes=height * width * strip(motes,,'%')   % 100
@.=hole                                          /*create the Brownian field, all empty.*/

  do j=1  for motes                              /*sprinkle a  # of dust motes randomly.*/
  rx=random(1, width);      ry=random(1,height);         @.rx.ry=mote
  end   /*j*/                                    /* [↑]  place a mote at random in field*/
                                                 /*plant the seed from which the tree   */
                                                 /*      will grow from dust motes that */
@.xs.ys=tree                                     /*      affixed themselves to others.  */
call show                                        /*show field before we mess it up again*/
tim=0                                            /*the time in seconds of last display. */
loX=1;  hiX= width                               /*used to optimize the  mote searching.*/
loY=1;  hiY=height                               /*  "   "     "      "    "      "     */

              /*═══════════════════════════════════════ soooo, this is Brownian motion. */
  do winks=1  for eons  until \motion            /*EONs is used instead of ∞, close 'nuf*/
  motion=0                                       /*turn off the  Brownian motion  flag. */
  if snapshot\==0  then  if winks//snapshot==0        then call show
  if snaptime\==0  then  do;  t=time('S')
                              if t\==tim & t//snaptime==0  then do;  tim=time('s')
                                                                     call show
                                                                end
                         end
  minX=loX;    maxX=hiX                          /*as the tree grows, the search for    */
  minY=loY;    maxY=hiY                          /*             dust motes gets faster. */
  loX= width;  hiX=1                             /*used to limit the mote searching.    */
  loY=height;  hiY=1                             /*  "   "   "    "    "      "         */

    do x  =minX  to maxX;    xm=x-1;  xp=x+1               /*a couple handy-dandy values*/
      do y=minY  to maxY;    if @.x.y\==mote  then iterate /*Not a mote:  keep looking. */
      if x<loX  then loX=x;  if x>hiX  then hiX=x          /*faster than: hiX=max(X hiX)*/
      if y<loY  then loY=y;  if y>hiY  then hiY=y          /*faster than: hiY=max(y hiY)*/
      if @.xm.y ==tree  then do;  @.x.y=tree; iterate; end         /*neighbor?*/
      if @.xp.y ==tree  then do;  @.x.y=tree; iterate; end         /*neighbor?*/
      ym=y-1
      if @.x.ym ==tree  then do;  @.x.y=tree; iterate; end         /*neighbor?*/
      if @.xm.ym==tree  then do;  @.x.y=tree; iterate; end         /*neighbor?*/
      if @.xp.ym==tree  then do;  @.x.y=tree; iterate; end         /*neighbor?*/
      yp=y+1
      if @.x.yp ==tree  then do;  @.x.y=tree; iterate; end         /*neighbor?*/
      if @.xm.yp==tree  then do;  @.x.y=tree; iterate; end         /*neighbor?*/
      if @.xp.yp==tree  then do;  @.x.y=tree; iterate; end         /*neighbor?*/
      motion=1                                   /* [↓]  Brownian motion is coming.     */
      xb=x + random(1, 3) - 2                    /*     apply Brownian motion for  X.   */
      yb=y + random(1, 3) - 2                    /*       "       "       "    "   Y.   */
      if @.xb.yb\==hole  then iterate            /*can the mote actually move to there ?*/
      @.x.y=hole                                 /*"empty out"  the old mote position.  */
      @.xb.yb=mote                               /*move the mote  (or possibly not).    */
      if xb<loX  then loX=max(1, xb);     if xb>hiX  then hiX=min( width, xb)
      if yb<loY  then loY=max(1, yb);     if yb>hiY  then hiY=min(height, yb)
      end   /*y*/                                /* [↑]  limit mote's movement to field.*/
    end     /*x*/

  call crop                                      /*crops (or truncates)  the mote field.*/
  end       /*winks*/

call show
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
crop: if loX>1  &  hiX<width  &  loY>1  &  hiY<height  then return    /*are we cropping?*/
                                                 /* [↓]  delete motes (moved off field).*/
              do yc=-1  to height+1  by height+2
                  do xc=-1  to width+1;   if @.xc.yc==hole  then iterate;     @.xc.yc=hole
                  end   /*xc*/
              end       /*yc*/
                                                 /* [↓]  delete motes (moved off field).*/
              do xc=-1  to width+1   by width+2
                  do yc=-1  to height+1;  if @.xc.yc==hole  then iterate;     @.xc.yc=hole
                  end   /*yc*/
              end       /*xc*/
      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: clearScr                                   /*¬ necessary, but everything speeds up*/
              do ys=height       for height  by -1;   aRow=
                        do xs=1  for width;           aRow=aRow || @.xs.ys
                        end   /*xs*/
              say aRow
              end             /*ys*/
return

/*REXX program shows  Brownian motion  of dust in a field with one seed.*/
parse arg height width motes randSeed .        /*get args from the C.L. */
if height=='' | height==','  then height=0     /*None?   Use the default*/
if  width=='' |  width==','  then  width=0     /*  "      "   "     "   */
if  motes=='' |  motes==','  then  motes='10%' /*% dust motes in field, */
                                       /* ··· otherwise just the number.*/
tree     = '*'                         /*an affixed dust speck  (tree). */
mote     = '·'                         /*char for a loose mote (of dust)*/
hole     = ' '                         /*char for an empty spot in field*/
clearScr = 'CLS'                       /*(DOS?) command to clear screen.*/
eons     = 1000000                     /* # cycles for Brownian movement*/
snapshot = 0                           /*every  n  winks, show snapshot.*/
snaptime = 1                           /*every  n  secs,  show snapshot.*/
seedPos  = 30 45                       /*place seed in this field pos.  */
seedPos  = 0                           /*if =0, use middle of the field.*/
                                       /*if -1, use a random placement. */
                                       /*otherwise, place it at seedPos.*/
                                       /*set RANDSEED for repeatability.*/
if datatype(randSeed,'W')  then call random ,,randSeed    /*if #, use it*/
                                       /* [↑]  set the 1st random number*/
if height==0 | width==0  then _=scrsize() /*not all REXXes have SCRSIZE.*/
if height==0             then height=word(_,1)-3    /*adjust for border.*/
if             width==0  then  width=word(_,2)-1    /*   "    "     "   */

                     seedAt=seedPos
if seedPos== 0  then seedAt=width%2 height%2
if seedPos==-1  then seedAt=random(1,width) random(1,height)
parse  var  seedAt    xs  ys  .        /*obtain  X & Y  seed coördinates*/
                                       /* [↓]  if right-most≡'%', use %.*/
if right(motes,1)=='%'  then motes=height * width * strip(motes,,'%') %100
@.=hole                                /*create the field, all empty.   */

  do j=1  for motes                    /*sprinkle # dust motes randomly.*/
  rx=random(1, width);      ry=random(1,height);         @.rx.ry=mote
  end   /*j*/                          /* [↑]  place a mote at random.  */
                                       /*plant the seed from which the  */
                                       /*tree will grow from dust motes */
@.xs.ys=tree                           /*that affixed themselves.       */
call show                              /*show field before we mess it up*/
tim=0                                  /*the time (in secs) of last show*/
loX=1;  hiX= width                     /*used to optimize mote searching*/
loY=1;  hiY=height                     /*  "   "     "      "      "    */

          /*═════════════════════════════soooo, this is Brownian motion.*/
  do winks=1  for eons  until \motion  /*EONs is used instead of  ∞.    */
  motion=0                             /*turn off Brownian motion flag. */
  if snapshot\==0  then  if winks//snapshot==0        then call show
  if snaptime\==0  then  do;  t=time('S')
                         if t\==tim & t//snaptime==0  then do
                                                           tim=time('s')
                                                           call show
                                                           end
                         end
  minX=loX;    maxX=hiX                /*as the tree grows, the search  */
  minY=loY;    maxY=hiY                /*   for dust motes gets faster. */
  loX= width;  hiX=1                   /*used to limit mote searching.  */
  loY=height;  hiY=1                   /*  "   "   "     "      "       */

    do x  =minX  to maxX;    xm=x-1;  xp=x+1
      do y=minY  to maxY;    if @.x.y\==mote  then iterate
      if x<loX  then loX=x;  if x>hiX  then hiX=x   /*is faster than: hiX=max(X hiX) */
      if y<loY  then loY=y;  if y>hiY  then hiY=y   /*is faster than: hiY=max(y hiY) */
      if @.xm.y ==tree  then do;  @.x.y=tree; iterate; end   /*neighbor?*/
      if @.xp.y ==tree  then do;  @.x.y=tree; iterate; end   /*neighbor?*/
      ym=y-1
      if @.x.ym ==tree  then do;  @.x.y=tree; iterate; end   /*neighbor?*/
      if @.xm.ym==tree  then do;  @.x.y=tree; iterate; end   /*neighbor?*/
      if @.xp.ym==tree  then do;  @.x.y=tree; iterate; end   /*neighbor?*/
      yp=y+1
      if @.x.yp ==tree  then do;  @.x.y=tree; iterate; end   /*neighbor?*/
      if @.xm.yp==tree  then do;  @.x.y=tree; iterate; end   /*neighbor?*/
      if @.xp.yp==tree  then do;  @.x.y=tree; iterate; end   /*neighbor?*/
      motion=1                         /* [↓] Brownian motion is coming.*/
      xb=x+random(1,3)-2               /*  apply Brownian motion for  X.*/
      yb=y+random(1,3)-2               /*    "       "       "    "   Y.*/
      if @.xb.yb\==hole  then iterate  /*can mote actually move there ? */
      @.x.y=hole                       /*empty out the old mote position*/
      @.xb.yb=mote                     /*move the mote (or possibly not)*/
      if xb<loX  then loX=max(1,xb);   if xb>hiX  then hiX=min( width, xb)
      if yb<loY  then loY=max(1,yb);   if yb>hiY  then hiY=min(height, yb)
      end   /*y*/                      /* [↑]  limit the motes movement.*/
    end     /*x*/
  call crop                            /*crops/truncates the mote field.*/
  end       /*winks*/

call show
exit                                   /*stick a fork in it, we're done.*/
/*────────────────────────────────CROP subroutine───────────────────────*/
crop: if loX>1 & hiX<width & loY>1 & hiY<height  then return /*cropping?*/

  do yc=-1  to height+1  by height+2   /*delete motes (moved off field).*/
      do xc=-1 to width+1;   if @.xc.yc==hole  then iterate;  @.xc.yc=hole
      end   /*xc*/
  end       /*yc*/

  do xc=-1  to width+1   by width+2    /*delete motes (moved off field).*/
      do yc=-1 to height+1;  if @.xc.yc==hole  then iterate;  @.xc.yc=hole
      end   /*yc*/
  end       /*xc*/
return
/*────────────────────────────────SHOW subroutine───────────────────────*/
show: clearScr                         /*not necessary, but speeds it up*/
              do ys=height       for height  by -1;   aRow=
                        do xs=1  for width;           aRow=aRow || @.xs.ys
                        end   /*xs*/
              say aRow
              end             /*ys*/
return

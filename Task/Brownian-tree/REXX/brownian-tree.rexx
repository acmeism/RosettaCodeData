/*REXX program shows brownian motion of dust in a field with one seed.  */
parse arg height width motes .
if height=='' | height==',' then height=0
if  width=='' |  width==',' then  width=0
if  motes=='' then  motes='10%'        /*nn%  Calculate # of dust motes.*/
                                       /* ... otherwise just the number.*/
tree ='*'                              /*an affixed dust speck  (tree). */
mote ='fa'x                            /*char for a loose mote (of dust)*/
empty=' '                              /*char for an empty spot in field*/
clearScr='CLS'                         /*(DOS?) command to clear screen.*/
eons=1000000                           /*time limit for browian movement*/
snapshot=0                             /*every  n  winks, show snapshot.*/
snaptime=2                             /*every  n  secs,  show snapshot.*/
seedPos=30 45                          /*place seed in this field pos.  */
seedPos=0                              /*if =0, use middle of the field.*/
                                       /*if -1, use random placement.   */
                                       /*otherwise, place it at seedPos.*/
randseed=0                             /*set RANDSEED for repeatability.*/
if randseed\==0 then call random ,,randseed    /*set the 1st random num.*/

if height==0 | width==0 then _=scrsize()  /*not all REXXes have SCRSIZE.*/
if height==0            then height=word(_,1)-3
if             width==0 then  width=word(_,2)-1

                    seedAt=seedPos
if seedPos== 0 then seedAt=width%2 height%2
if seedPos==-1 then seedAt=random(1,width) random(1,height)
parse var seedAt xs ys .

if right(motes,1)=='%' then motes=height*width*strip(motes,,'%')%100
@.=empty                               /*create the field, all empty.   */

  do j=1  for motes                    /*sprinkle dust motes randomly.  */
  rx=random(1, width);   ry=random(1,height);   @.rx.ry=mote
  end   /*j*/
                                       /*plant the seed from which the  */
                                       /*tree will grow from dust motes */
@.xs.ys=tree                           /*that affixed themselves.       */
call show                              /*show field before we mess it up*/
tim=0                                  /*the time (in secs) of last show*/
loX=1;  hiX= width                     /*used to optimize mote searching*/
loY=1;  hiY=height                     /*  "   "     "      "      "    */

          /*═════════════════════════════soooo, this is brownian motion.*/
  do winks=1  for eons  until \motion  /*EONs is used just in case of ∞.*/
  motion=0                             /*turn off brownian motion flag. */
  if snapshot \== 0  then  if winks//snapshot==0       then call show
  if snaptime \== 0  then  do;  t=time('S')
                           if t\==tim & t//snaptime==0 then do
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
      if x<loX then loX=x;   if x>hiX  then hiX=x   /*is faster than: hiX=max(X hiX) */
      if y<loY then loY=y;   if y>hiY  then hiY=y   /*is faster than: hiY=max(y hiY) */
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
      motion=1                         /*brownian motion is coming up.  */
      xb=x+random(1,3)-2               /*apply brownian motion for  X.  */
      yb=y+random(1,3)-2               /*apply brownian motion for  Y.  */
      if @.xb.yb\==empty  then iterate /*can the mote move there ?      */
      @.x.y=empty                      /*"blank" out the old position.  */
      @.xb.yb=mote                     /*move the mote (or possibly not)*/
      if xb<loX  then loX=max(1,xb);   if xb>hiX  then hiX=min( width,xb)
      if yb<loY  then loY=max(1,yb);   if yb>hiY  then hiY=min(height,yb)
      end   /*y*/
    end     /*x*/
  call crop
  end       /*winks*/

call show
exit                                   /*stick a fork in it, we're done.*/
/*────────────────────────────────SHOW subroutine───────────────────────*/
show: clearScr                         /*not necessary, but speeds it up*/
                 do ys=height by -1 for height;  aRow=
                           do xs=1 for width;  aRow=aRow||@.xs.ys
                           end   /*xs*/
                 say aRow
                 end             /*ys*/
return
/*────────────────────────────────CROP subroutine───────────────────────*/
crop: if loX>1 & hiX<width & loY>1 & hiY<height then return  /*cropping?*/

  do yc=-1 to height+1 by height+2     /*delete motes (moved off field).*/
      do xc=-1 to width+1;   if @.xc.yc==empty then iterate; @.xc.yc=empty
      end   /*xc*/
  end       /*yc*/

  do xc=-1 to width+1 by width+2       /*delete motes (moved off field).*/
      do yc=-1 to height+1;  if @.xc.yc==empty then iterate; @.xc.yc=empty
      end   /*yc*/
  end       /*xc*/
return

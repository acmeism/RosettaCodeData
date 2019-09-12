/*REXX program cuts rectangles into two symmetric pieces,  the rectangles are cut along */
/*────────────────────────────────────────────────── unit dimensions and may be rotated.*/
numeric digits 20                                /*be able to handle some big integers. */
parse arg N .;    if N=='' | N==","  then N=10   /*N  not specified?   Then use default.*/
dir.=0;   dir.0.1= -1;   dir.1.0= -1;   dir.2.1= 1;   dir.3.0= 1     /*the 4 directions.*/

     do   y=2   to N;   yEven= y//2;     say     /*calculate rectangles up to size  NxN.*/
       do x=1  for y;   if x//2  then if yEven  then iterate       /*not if both X&Y odd*/
       z= solve(y,x,1); _=comma(z); _=right(_, max(14, length(_))) /*align the output.  */
       say right(y, 9)    "x"    right(x, 2)    'rectangle can be cut'    _     "way"s(z).
       end   /*x*/
     end     /*y*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
comma: procedure; arg _;  do k=length(_)-3  to 1  by -3; _=insert(',',_,k); end;  return _
s:     if arg(1)=1  then return arg(3);   return word(arg(2) 's', 1)       /*pluralizer.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
solve: procedure expose # dir. @. h len next. w; @.=0      /*zero rectangle coördinates.*/
       parse arg h,w,recur                                 /*get values for some args.  */
       if h//2  then do;    t= w;    w= h;      h= t;      if h//2  then return 0
                     end
       if w==1  then return 1
       if w==2  then return h
       if h==2  then return w                    /* [↓]   %  is REXX's integer division.*/
       cy= h % 2;     cx= w % 2;     wp= w + 1   /*cut the  [XY]  rectangle in half.    */
       len= (h+1) * wp - 1                       /*extend the area of the rectangle.    */
       next.0= -1;    next.1= -wp;   next.2= 1;    next.3= wp    /*direction & distance.*/
       if recur  then #= 0
              do x=cx+1  to  w-1;    t= x + cy*wp;     @.t= 1;     _= len - t;      @._= 1
              call walk cy-1, x
              end   /*x*/
       #= #+1
       if h==w  then #= # + #                    /*double the count of rectangle cuts.  */
                else if w//2==0  then if recur  then call solve w, h, 0
       return #
/*──────────────────────────────────────────────────────────────────────────────────────*/
walk:  procedure expose # dir. @. h len next. w wp;       parse arg y,x
       if y==h  then do;   #= #+2;   return;   end    /* ◄──┐      REXX short circuit.  */
       if x==0  then do;   #= #+2;   return;   end    /* ◄──┤        "    "      "      */
       if x==w  then do;   #= #+2;   return;   end    /* ◄──┤        "    "      "      */
       if y==0  then do;   #= #+2;   return;   end    /* ◄──┤        "    "      "      */
       t= x + y*wp;  @.t= @.t + 1;   _= len - t       /*    │ordered by most likely ►──┐*/
       @._= @._+1                                     /*    └──────────────────────────┘*/
                     do j=0  for 4;  _= t + next.j    /*try each of the four directions.*/
                     if @._==0  then do;   yn= y + dir.j.0;     xn= x + dir.j.1
                                           if yn==h  then do;   #= #+2;   iterate;   end
                                           if xn==0  then do;   #= #+2;   iterate;   end
                                           if xn==w  then do;   #= #+2;   iterate;   end
                                           if yn==0  then do;   #= #+2;   iterate;   end
                                           call walk  yn, xn
                                     end
                     end   /*j*/
       @.t= @.t - 1
       _= len - t;       @._= @._ - 1;     return

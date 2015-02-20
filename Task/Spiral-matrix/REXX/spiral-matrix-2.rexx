/*REXX program displays a  spiral  in a  square array  (of any size).   */
parse arg size .                       /*get the array size from the CL.*/
if size==''  then size=5               /*No argument?  Then use default.*/
tot=size**2                            /*total  # of elements in spiral.*/
k=size                                 /*K is the counter for the spiral*/
row=1;   col=0;   start=0              /*start at row 1, col 0,  with 0.*/
/*──────────────────────────────────────────────construct the spiral #s.*/
      do n=start  for k; col=col+1; @.col.row=n; end;   if k==0  then exit
                                       /* [↑]  build first row of spiral*/
  do until  n>=tot                                      /*spiral matrix.*/
     do one=1  to -1  by -2  until n>=tot;   k=k-1      /*perform twice.*/
       do n=n  for k;  row=row+one;  @.col.row=n;  end  /*for the row···*/
       do n=n  for k;  col=col-one;  @.col.row=n;  end  /* "   "  col···*/
     end   /*one*/                                      /* ↑↓ direction.*/
  end      /*until n≥tot*/             /* [↑]   done with matrix spiral.*/
/*──────────────────────────────────────────────display spiral to screen*/
  do twice=0 for 2; if \twice then !.=0 /*1st time?  Find max col width.*/
    do   row=1  for size;  _=           /*construct display row by row. */
      do col=1  for size;  x=@.col.row  /*construct a line  col by col. */
      if twice  then _=_ right(x,!.col) /*construct a line  for display.*/
                else !.col=max(!.col,length(x))   /*find width of column*/
      end   /*col*/                     /* [↓]  line has an extra blank.*/
    if twice  then say substr(_,2)      /*SUBSTR ignores the 1st blank. */
    end     /*row*/                     /*stick a fork in it, we're done*/
  end       /*twice*/

/*REXX program illustrates first-class environments (using hailstone #s)*/
parse arg N .;   if N==''  then N=12   /*Was N defined? No, use default.*/
w=length(N)                            /*the width (so far) for columns.*/
@.=
  do init=1  for N;  @.init=init;  end /*initialize all the environments*/

  do forever  until @.0;  @.0=1        /* ◄─── process all environments.*/
      do k=1  for N;  x=hailstone(k);  w=max(w,length(x))
      @.k=@.k  x                       /*where the rubber meets the road*/
      end   /*k*/
  end       /*forever*/

count=0                                /* [↓]   show tabular results.   */
         do lines=-1  until _==''; _=  /*process each line for each env.*/
              do j=1  for N            /*process each environment.      */
                   select              /*choose how to process the line.*/
                   when count== 1  then _=_ right(words(@.j)-1, w)
                   when lines==-1  then _=_ right(j,  w)          /*hdr.*/
                   when lines== 0  then _=_ right('', w, '─')     /*sep.*/
                   otherwise            _=_ right(word(@.j, lines), w)
                   end   /*select*/
              end        /*j*/

         if count==1  then count=2
         _=strip(_,'T');   if _==''  then count=count+1  /*if null, bump*/
         if count==1  then _=copies(" "left('', w, "═"), N)   /*foot sep*/
         if _\==''    then say substr(_,2)     /*show the (foot) counts.*/
         end             /*lines*/
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────HAILSTONE (Collatz) subroutine───*/
hailstone:  procedure expose @.;  parse arg y;    _=word(@.y, words(@.y))
if _==1  then return '' ; @.0=0; if _//2==0  then return _%2; return _*3+1

/*REXX program demonstrates a  method  for  catamorphism  for some simple functions.    */
@list= 1 2 3 4 5 6 7 8 9 10
                                say 'list:'     fold(@list,  "list")
                                say ' sum:'     fold(@list,  "+"   )
                                say 'prod:'     fold(@list,  "*"   )
                                say ' cat:'     fold(@list,  "||"  )
                                say ' min:'     fold(@list,  "min" )
                                say ' max:'     fold(@list,  "max" )
                                say ' avg:'     fold(@list,  "avg" )
                                say ' GCD:'     fold(@list,  "GCD" )
                                say ' LCM:'     fold(@list,  "LCM" )
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
fold: procedure;  parse arg z;  arg ,f;         z = space(z);      BIFs= 'MIN MAX LCM GCD'
      za= translate(z, f, ' ');                 zf= f"("translate(z, ',' , " ")')'
      if f== '+' | f=="*"       then interpret  "return"  za
      if f== '||'               then return  space(z, 0)
      if f== 'AVG'              then interpret  "return"  fold(z, '+')    "/"    words(z)
      if wordpos(f, BIFs)\==0   then interpret  "return"  zf
      if f=='LIST' | f=="SHOW"  then return z
      return 'illegal function:'     arg(2)
/*──────────────────────────────────────────────────────────────────────────────────────*/
GCD:  procedure;  $=;                          do j=1  for arg();    $= $ arg(j)
                                               end   /*j*/
      parse var $ x z .;    if x=0  then x= z                  /* [↑] build an arg list.*/
      x= abs(x)
                         do k=2  to words($);  y= abs( word($, k));   if y=0  then iterate
                           do until _=0;       _= x // y;      x= y;     y= _
                           end   /*until*/
                         end   /*k*/
      return x
/*──────────────────────────────────────────────────────────────────────────────────────*/
LCM:  procedure;  $=;    do j=1  for arg();     $= $ arg(j)
                         end   /*j*/
      x= abs(word($, 1))                                       /* [↑] build an arg list.*/
                         do k=2  to words($);   != abs(word($, k));  if !=0  then return 0
                         x= x*!  /  GCD(x, !)                  /*GCD does the heavy work*/
                         end   /*k*/
      return x

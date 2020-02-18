/*REXX program compresses text using the  LZW  (Lempel─Ziv─Welch), and reconstitutes it.*/
parse arg x;     if x=''  then                   /*get an optional argument from the CL.*/
          x= '"There is nothing permanent except change."   ───  Heraclitus  [540-475 BC]'
       say 'original text='        x             /* [↑]  Not specified? Then use default*/
cypher= LZWc(x)                                  /*compress text using the LZW algorithm*/
       say 'reconstituted='   LZWd(cypher)       /*display the reconstituted string.    */
       say ' LZW integers='        cypher        /*   "     "  LZW  integers used.      */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
LZWc: procedure; parse arg y,,w $ @.;            #= 256        /*LZW compress algorithm.*/
                                     do j=0  for #;    _= d2c(j);    @._= j;    end  /*j*/
       do k=1  for length(y)+1;            z= w || substr(y, k, 1)
       if @.z==''  then do;  $= $ @.w;   @.z= #;    #= # + 1;    w= substr(y, k, 1);   end
                   else w= z                                   /*#: the dictionary size.*/
       end   /*k*/;                      return substr($, 2)   /*elide a leading blank. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
LZWd: procedure; parse arg x y,,@.;              #= 256      /*LZW decompress algorithm.*/
                                     do j=0  for #;      @.j= d2c(j);      end  /*j*/
      $= @.x;   w= $                                         /*#:   the dictionary size.*/
                       do k=1  for words(y);             z= word(y, k)
                       if @.z\=='' | @.k==" "  then ?= @.z
                                               else if z==#  then ?= w || left(w, 1)
                       $= $ || ?
                       @.#= w || left(?, 1);   #= # + 1;          w= ?
                       end   /*k*/;            return $

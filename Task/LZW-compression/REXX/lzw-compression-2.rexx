/*REXX program compresses text using the  LZW  (Lempel─Ziv─Welch), and reconstitutes it.*/
$$$= '"There is nothing permanent except change."   ───   Heraclitus  [540 ── 475 BCE]'
parse arg text;   if text=''  then text= $$$     /*get an optional argument from the CL.*/
             say 'original text='  text          /* [↑]  Not specified? Then use default*/
cypher= LZWc(text)                               /*compress text using the LZW algorithm*/
             say 'reconstituted='  LZWd(cypher)  /*display the reconstituted string.    */
say;         say ' LZW integers='       cypher   /*   "     "  LZW  integers used.      */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
LZWi: arg i,@.; #=256;  do j=0  for #; _=d2c(j); if i  then @.j=_; else @._=j; end; return
/*──────────────────────────────────────────────────────────────────────────────────────*/
LZWc: procedure; parse arg y,,$;  call LZWi 0; w=                      /*LZW   compress.*/
        do k=1  for length(y)+1;            z= w || substr(y, k, 1)
        if @.z==''  then do;  $= $ @.w;   @.z= #;   #= # + 1;   w= substr(y, k, 1);   end
                    else w= z                                  /*#: the dictionary size.*/
        end   /*k*/;                      return substr($, 2)  /*elide a leading blank. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
LZWd: procedure; parse arg x y;   call LZWi 1;    $= @.x;       w= $   /*LZW decompress.*/
        do k=1  for words(y);             z= word(y, k)
        if @.z\=='' | @.k==" "  then ?= @.z
                                else if z==#  then ?= w || left(w, 1)
        $= $ || ?
        @.#= w || left(?, 1);   w= ?;     #= # + 1                     /*bump dict. size*/
        end   /*k*/;                      return $

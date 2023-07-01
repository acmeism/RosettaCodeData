/*REXX pgm performs deconvolution of two arrays:    deconv(g,f)=h   and   deconv(g,h)=f */
call make 'H',  "-8 -9 -3 -1 -6 7"
call make 'F',  "-3 -6 -1 8 -6 3 -1 -9 -9 3 -2 5 2 -2 -7 -1"
call make 'G',  "24 75 71 -34 3 22 -45 23 245 25 52 25 -67 -96 96 31 55 36 29 -43 -7"
call show 'H'                                    /*display the elements of array  H.    */
call show 'F'                                    /*   "     "     "      "   "    F.    */
call show 'G'                                    /*   "     "     "      "   "    G.    */
call deco 'G',  "F", 'X'                         /*deconvolution of  G  and  F  ───►  X */
call test 'X',  "H"                              /*test: is array  H  equal to array  X?*/
call deco 'G',  "H", 'Y'                         /*deconvolution of  G  and  H  ───►  Y */
call test 'F',  "Y"                              /*test: is array  F  equal to array  Y?*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
deco: parse arg $1,$2,$r;   b= @.$2.# + 1;   a= @.$1.# + 1      /*get sizes of array 1&2*/
      @.$r.#= a - b                                             /*size of return array. */
            do n=0  to a-b                                      /*define  return array. */
            @.$r.n= @.$1.n                                      /*define RETURN element.*/
            if n<b  then L= 0                                   /*define the variable L.*/
                    else L= n - b + 1                           /*   "    "     "     " */
            if n>0  then do j=L  to n-1;                _= n-j  /*define elements > 0.  */
                         @.$r.n= @.$r.n - @.$r.j * @.$2._       /*compute   "     " "   */
                         end   /*j*/                            /* [↑] subtract product.*/
            @.$r.n= @.$r.n / @.$2.0                             /*divide array element. */
            end   /*n*/;                     return
/*──────────────────────────────────────────────────────────────────────────────────────*/
make: parse arg $,z;                     @.$.#= words(z) - 1    /*obtain args; set size.*/
            do k=0  to @.$.#;            @.$.k= word(z, k + 1)  /*define array element. */
            end   /*k*/;                     return             /*array starts at unity.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: parse arg $,z,_;    do s=0  to @.$.#;  _= strip(_ @.$.s)  /*obtain the arguments. */
                          end   /*s*/                           /* [↑]  build the list. */
      say 'array' $": " _;                   return             /*show the list;  return*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
test: parse arg $1,$2;    do t=0  to max(@.$1.#, @.$2.#)        /*obtain the arguments. */
                          if @.$1.t= @.$2.t  then iterate       /*create array list.    */
                          say "***error*** arrays"   $1    ' and '    $2   "aren't equal."
                          end   /*t*/;       return             /* [↑]  build the list. */

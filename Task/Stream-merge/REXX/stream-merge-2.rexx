/*REXX pgm reads sorted files (1.TXT, 2.TXT, ···),  and writes sorted data ───► ALL.TXT */
@.=copies('ff'x, 1e4); call lineout 'ALL.TXT',,1 /*no value should be larger than this. */
     do n=1  until @.n==@.;   call rdr n;   end  /*read any number of appropriate files.*/
n=n-1                                            /*fix N 'cause read a non─existent file*/
     do forever;              y=@.;   #=0        /*find the lowest value for  N  values.*/
       do k=1  for n; if @.k==@. then call rdr k /*Not defined?  Then read a file record*/
       if @.k<<y   then do;   y=@.k;  #=k;  end  /*Lowest so far?  Mark this as minimum.*/
       end   /*k*/                               /* [↑]  note use of  << (exact compare)*/
     if #==0  then exit                          /*stick a fork in it,  we're all done. */
     call lineout  'ALL.TXT', @.#;    say @.#    /*write value to a file;  also display.*/
     call rdr #                                  /*re─populate a value from the # file. */
     end   /*forever*/                           /*keep reading/merging until exhausted.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
rdr: arg z;    @.z= @.;    f= z'.TXT';    if lines(f)\==0  then @.z= linein(f);     return

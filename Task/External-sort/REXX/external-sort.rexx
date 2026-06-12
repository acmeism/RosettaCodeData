/*REXX pgm reads a file, splits into smaller files, sorts 'em, combines into sorted file*/
parse arg FID n lim seed .                       /*obtain optional arguments from the CL*/
if  FID=='' | FID==","  then FID= 'SORT_EXT.OUT' /*name of the  output  (sorted)  file. */
if    n=='' |   n==","  then   n=   500          /*number of records (rand #s) to gen.  */
if  lim=='' | lim==","  then lim=    10          /*number of records per SORTWORK file. */
if datatype(seed, 'W')  then call random ,,seed  /*Numeric?  Then use it as a rand seed.*/
sWork = 'SORTWORK.'                              /*the filename of the  SORTWORK  files.*/
call gen n,lim                                   /*generate   SORTWORK.nnn  files.      */
call srt #                                       /*sort records in all  SORTWORK  files.*/
call mrg                                         /*merge records in the SORTWORK  files.*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
mrg: procedure expose FID sWork;   parse arg #   /*#:   the number of  SORTWORK  files. */
     @.= copies('ff'x, 1e5)                      /*no value should be larger than this. */
     call lineout FID, , 1                       /*position the output file at rec # 1. */

        do j=1  until @.j==@.;     call rdr j    /*read any number of  SORTWORK  files, */
        end   /*j*/                              /*but initially just 1 record per file.*/

     j= j - 1                                    /*adj. J; read from a non─existent file*/

        do forever;                y= @.         /*find the lowest value for  N  values.*/
        z= 0
             do k=1  for j                       /*traipse through the stemmed  @ array.*/
             if @.k==@.  then call rdr k         /*Not defined?  Then read a file record*/
             if @.k<<y  then do;   y= @.k        /*Lowest so far? Then mark this as min.*/
                                   z= k
                             end
             end   /*k*/                         /* [↑]  note use of << exact comparison*/

        if z==0  then leave                      /*Any more records?   No, close file.  */
        call lineout FID, @.z                    /*write the value to the output file.  */
        call rdr z                               /*re-populate a value from the # file. */
        end   /*forever*/                        /*keep reading/merging until exhausted.*/

     call lineout FID                            /*close the output file (just in case).*/
     'ERASE'  sWORK"*"                           /*delete all the  SORTWORK  files.     */
     return
/*──────────────────────────────────────────────────────────────────────────────────────*/
gen: procedure expose #;          parse arg m,siz;       d= digits()  /*used for justify*/
     # = 0                                       /*number of  SORTWORK.nnn  files so far*/
           do j=1  for m;           #= 1   +   j % siz                /*create workfile#*/
           call lineout  'SORTWORK.'#, right(random(, 1e5), d)        /*write rand #.   */
           end   /*j*/
                         do k=1  for #;  call lineout 'SORTWORK.'#    /*close a workfile*/
                         end   /*k*/
           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
rdr: parse arg a;  @.a=@.;  f= sWork || a;  if lines(f)\==0  then @.a= linein(f);   return
/*──────────────────────────────────────────────────────────────────────────────────────*/
srt: procedure expose sWork;  parse arg #
           do j=1  for #;   fn= sWORK || j;  'SORT'  fn  "/O" fn;  end  /*j*/;      return

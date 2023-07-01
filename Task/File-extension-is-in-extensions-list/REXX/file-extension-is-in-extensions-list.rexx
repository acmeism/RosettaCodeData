/*REXX pgm displays if a filename has a known extension  (as per a list of extensions). */
$= 'zip rar 7z gz archive A## tar.bz2';  upper $ /*a list of "allowable" file extensions*/
parse arg fn                                     /*obtain optional argument from the CL.*/
@.=                                              /*define the default for the  @. array.*/
if fn\=''  then       @.1 =  strip(fn)           /*A filename specified?   Then use it. */
           else do;   @.1 = "MyData.a##"         /*No    "        "        Else use list*/
                      @.2 = "MyData.tar.Gz"
                      @.3 = "MyData.gzip"
                      @.4 = "MyData.7z.backup"
                      @.5 = "MyData..."
                      @.6 = "MyData"
                      @.7 = "MyData_v1.0.tar.bz2"
                      @.8 = "MyData_v1.0.bz2"
                end
#= words($)

  do j=1  while @.j\=='';   @@= @.j;   upper @@  /*traipse through @ file extension list*/
      do k=1  for #  until right(@@, L)==x       /*Search $ list, is extension in list? */
      x= . || word($, k);  L=length(x)           /*construct the extension of the file. */
      end   /*k*/                                /* [↓]  display file, and a nay or yea.*/
  say  right(@.j, 40)     ' '      right( word( "false true",  1 + (k<=#) ),  5)
  end       /*j*/                                /*stick a fork in it,  we're all done. */

/*REXX program displays eight colored vertical bars on the full screen. */
parse  value  scrsize()  with sd sw .              /*screen depth,width.*/
barWidth=sw%8                                      /*calculate bar width*/
_.=copies('db'x,barWidth)                          /*the bar, full width*/
_.8=left(_.,barWidth-1)                            /*last bar width.    */
    $ = x2c('1b5b73') || x2c('1b5b313b33376d')     /* preamble, header. */
hdr.1 = x2c('1b5b303b33306d')                      /* the color black.  */
hdr.2 = x2c('1b5b313b33316d')                      /* the color red.    */
hdr.3 = x2c('1b5b313b33326d')                      /* the color green.  */
hdr.4 = x2c('1b5b313b33346d')                      /* the color blue.   */
hdr.5 = x2c('1b5b313b33356d')                      /* the color magenta.*/
hdr.6 = x2c('1b5b313b33366d')                      /* the color cyan.   */
hdr.7 = x2c('1b5b313b33336d')                      /* the color yellow. */
hdr.8 = x2c('1b5b313b33376d')                      /* the color white.  */
 tail = x2c('1b5b751b5b303b313b33363b34303b306d')  /* epilogue, trailer.*/
                                       /* [↓]  last bar width is shrunk.*/
       do j=1  for 8                   /*build the line, color by color.*/
       $=$ || hdr.j || _.j             /*append the color header + bar. */
       end   /*j*/                     /* [↑]  color order is the list. */
                                       /* [↓]  the tail is overkill.    */
$=$ || tail                            /*append the epilogue (trailer). */
                                       /* [↓]  show full screen of bars.*/
       do k=1  for sd                  /*SD = screen depth (from above).*/
       say $                           /*have REXX display line of bars.*/
       end   /*k*/                     /* [↑]  Note:  SD  could be zero.*/
                                       /*stick a fork in it, we're done.*/

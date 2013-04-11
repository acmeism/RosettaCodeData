/*REXX program sorts an array using the  bubble-sort  method.           */

call gen@                              /*generate the array elements.   */
call show@ 'before sort'               /*show the before array elements.*/
call bubbleSort highItem               /*invoke the bubble sort.        */
call show@ ' after sort'               /*show the  after array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────BUBBLESORT subroutine───────────────*/
bubbleSort: procedure expose @.; parse arg n    /* n = number of items. */
                                       /*diminish # items each time.    */
  do until done                        /*sort until it's done.          */
  done=1                               /*assume it's done  (1 = true).  */
         do j=1 for n-1                /*sort  M  items this time.      */
          k=j+1                        /*point to the next item.        */
          if @.j>@.k then do           /*is it out of order ?           */
                          _=@.j        /*assign to a temp variable.     */
                          @.j=@.k      /*swap current with next.        */
                          @.k=_        /*... and next with _            */
                          done=0       /*indicate it's not done.        */
                          end          /*   1=true    0=false           */
          end   /*j*/
  end           /*until done*/
return
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@: @.=                              /*assign some default values.    */
@.1 ='---letters of the Hebrew alphabet---'    ;    @.13='kaph    [kaf]'
@.2 ='===================================='    ;    @.14='lamed'
@.3 ='aleph   [alef]'                          ;    @.15='mem'
@.4 ='beth    [bet]'                           ;    @.16='nun'
@.5 ='gimel'                                   ;    @.17='samekh'
@.6 ='daleth  [dalet]'                         ;    @.18='ayin'
@.7 ='he'                                      ;    @.19='pe'
@.8 ='waw     [vav]'                           ;    @.20='sadhe   [tsadi]'
@.9 ='zayin'                                   ;    @.21='qoph    [qof]'
@.10='heth    [het]'                           ;    @.22='resh'
@.11='teth    [tet]'                           ;    @.23='shin'
@.12='yod'                                     ;    @.24='taw     [tav]'

  do highItem=1 while @.highItem\==''  /*find how many entries.         */
  end   /*highitem*/

highItem=highItem-1                    /*adjust highItem slightly.      */
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@: widthH=length(highItem)         /*maximum width of any line.     */
                    do j=1 for highItem
                    say 'element' right(j,widthH) arg(1)':' @.j
                    end
say copies('-',80)                     /*show a separator line.         */
return

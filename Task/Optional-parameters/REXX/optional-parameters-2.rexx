/*REXX example uses the  SortStrings  subroutine with some (passed) optional arguments. */


@.1= 'one';  @.2= "two";  @.3= 'three'           /*define an array (@.) of strings here.*/


call sortStrings  'Reverse=no'  3
                                                 /*stick a fork in it,  we're all done. */

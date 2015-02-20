/*REXX program  demonstrates a  simple  array usage.                    */
a.='not found'                         /*value for all  a.xxx  (so far).*/
                do j=1  to 100         /*start at 1, define 100 elements*/
                a.j=-j*1000            /*define as negative J thousand. */
                end   /*j*/            /*the above defines 100 elements.*/

say 'element 50 is:'   a.50
say 'element 3000 is:' a.3000
                                       /*stick a fork in it, we're done.*/

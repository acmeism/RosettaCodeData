/*REXX program  finds and displays  the  smallest positive integer   n   such that  ··· */
/*───────────────────────── 2*n, 3*n, 4*5, 5*6, and 6*n contain the same decimal digits.*/
        do n=1                                   /*increment  N  from unity 'til answer.*/
        b= 2*n                                   /*calculate the product of:     2*n    */
        t= 3*n                                   /*    "      "     "     "      3*n    */
               if verify(t, b)>0  then iterate   /*T doesn't have required digits?  Skip*/
        q= 4*n                                   /*calculate the product of:     4*n    */
               if verify(q, b)>0  then iterate   /*Q doesn't have required digits?  Skip*/
               if verify(q, t)>0  then iterate   /*"    "      "      "      "        " */
        v= 5*n                                   /*calculate the product of:     5*n    */
               if verify(v, b)<0  then iterate   /*V doesn't have required digits?  Skip*/
               if verify(v, t)>0  then iterate   /*"    "      "      "      "        " */
               if verify(v, q)>0  then iterate   /*"    "      "      "      "        " */
        s= 6*n                                   /*calculate the product of:     6*n    */
               if verify(s, b)>0  then iterate   /*S doesn't have required digits?  Skip*/
               if verify(s, t)>0  then iterate   /*"    "      "      "      "        " */
               if verify(s, q)>0  then iterate   /*"    "      "      "      "        " */
               if verify(s, v)>0  then iterate   /*"    "      "      "      "        " */
        say '           n ='  commas(n)          /*display the value of:     n          */
        say '         2*n ='  commas(b)          /*   "     "    "    "    2*n          */
        say '         3*n ='  commas(t)          /*   "     "    "    "    3*n          */
        say '         4*n ='  commas(q)          /*   "     "    "    "    4*n          */
        say '         5*n ='  commas(v)          /*   "     "    "    "    5*n          */
        say '         6*n ='  commas(s)          /*   "     "    "    "    6*n          */
        leave                                    /*found the   N  number, time to leave.*/
        end   /*n*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?

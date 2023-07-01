aaa. = '───────nope.'                  /*assign this string as a default*/
aaa.1=1                                /*assign   1   to first  element.*/
aaa.4=4.                               /*   "     4    " fourth    "    */
aaa.7='lucky'                          /*   "     7    " seventh   "    */
              do j=0  to 8             /*go through a bunch of elements.*/
              say 'aaa.'||j '=' aaa.j  /*display element # and its value*/
              end                      /*we could've started J at  -100.*/

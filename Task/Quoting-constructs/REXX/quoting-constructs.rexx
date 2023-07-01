/*REXX program demonstrates various ways to express a string of characters  or  numbers.*/
a= 'This is one method of including a '' (an apostrophe) within a string.'
b= "This is one method of including a ' (an apostrophe) within a string."

                                                 /*sometimes,  an apostrophe is called  */
                                                 /*a quote.                             */
/*──────────────────────────────────────────────────────────────────────────────────────*/
c= "This is one method of including a "" (a double quote) within a string."
d= 'This is one method of including a " (a double quote) within a string.'

                                                 /*sometimes,  a double quote is also   */
                                                 /*called a quote,  which can make for  */
                                                 /*some confusion and bewilderment.     */
/*──────────────────────────────────────────────────────────────────────────────────────*/
f= 'This is one method of expressing a long literal by concatenations,  the '     ||  ,
   'trailing character of the above clause must contain a trailing '              ||  ,
   'comma (,)  === note the embedded trailing blank in the above 2 statements.'
/*──────────────────────────────────────────────────────────────────────────────────────*/
g= 'This is another method of expressing a long literal by '         ,
   "abutments,  the trailing character of the above clause must "    ,
   'contain a trailing comma (,)'
/*──────────────────────────────────────────────────────────────────────────────────────*/
h= 'This is another method of expressing a long literal by '       ,  /*still continued.*/
   "abutments,  the trailing character of the above clause must "                  ,
   'contain a trailing comma (,)  ---  in this case, the comment  /* ... */  is '   ,
   'essentially is not considered to be "part of" the REXX clause.'
/*──────────────────────────────────────────────────────────────────────────────────────*/
i= 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101 103 107 109

                                                 /*This is one way to express a list of */
                                                 /*numbers that don't have a sign.      */
/*──────────────────────────────────────────────────────────────────────────────────────*/
j= 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101 103 107 109,
   71 73 79 83 89 97 101 103 107 109 113 127 131 137 139 149 151 157 163 167 173 179 181

                                                 /*This is one way to express a long    */
                                                 /*list of numbers that don't have a    */
                                                 /*sign.                                */
                                                 /*Note that this form of continuation  */
                                                 /*implies a blank is abutted to first  */
                                                 /*part of the REXX statement.          */
                                                 /*Also note that some REXXs have a     */
                                                 /*maximum clause length.               */
/*──────────────────────────────────────────────────────────────────────────────────────*/
k= 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101 103 107 109,
   71 73   79 83 89 97 101 103 107 109 113 127 131 137 139 149 151 157 163 167 173 179 181

                                                 /*The  J  and  K  values are identical,*/
                                                 /*superfluous and extraneous blanks are*/
                                                 /*ignored.                             */
/*──────────────────────────────────────────────────────────────────────────────────────*/
l= '-2 3 +5 7 -11 13 17 19 -23 29 -31 37 -41 43 47 -53 59 -61 67 -71 73 79 -83 89 97 -101'

                                                 /*This is one way to express a list of */
                                                 /*numbers that have a sign.            */
/*──────────────────────────────────────────────────────────────────────────────────────*/
m= a b c d f g h i j k l                         /*this will create a list of all the   */
                                                 /*listed strings used  (so far)  into  */
                                                 /*the variable     L      (with an     */
                                                 /*intervening blank between each       */
                                                 /*variable's value.                    */

/*REXX program finds  symmetric difference  and  symmetric AND  (between two lists).    */
a= '["John", "Serena", "Bob", "Mary", "Serena"]' /*note the duplicate element:  Serena  */
b= '["Jim", "Mary", "John", "Jim", "Bob"]'       /*  "   "       "       "      Jim     */
a.=0;   SD.=0;   SA.=0;    SD=;     SA=          /*falsify booleans; zero & nullify vars*/
a.1=a;         say '──────────────list A ='  a   /*assign a list and display it to term.*/
a.2=b;         say '──────────────list B ='  b   /*   "   "   "   "     "     "  "   "  */
                                                 /* [↓]  parse the two lists.           */
    do k=1  for 2                                /*process both lists  (stemmed array). */
    a.k=strip( strip(a.k, , "["), ,']')          /*strip leading and trailing brackets. */
               do j=1  until a.k=''              /*parse names  [they may have blanks]. */
               a.k=strip(a.k, , ',')             /*strip all commas (if there are any). */
               parse var  a.k   '"'  _  '"'  a.k /*obtain the name of the list.         */
               a.k.j=_                           /*store the name of the list.          */
               a.k._=1                           /*make a boolean value.                */
               end   /*j*/
    a.k.0=j-1                                    /*the number of this list  (of names). */
    end              /*k*/
say                                              /* [↓]  find the symmetric difference. */
    do k=1  for 2;             ko=word(2 1, k)   /*process both lists;   KO=other list. */
      do j=1  for a.k.0;       _=a.k.j           /*process the list names.              */
      if \a.ko._ & \SD._  then do;   SD._=1      /*if not in both, then  ···            */
                               SD=SD  '"'_'",'   /*add to symmetric difference list.    */
                               end
      end   /*j*/
    end     /*k*/
                                                 /* [↓]  SD ≡  symmetric difference.    */
SD= "["strip( strip(SD), 'T', ",")']'            /*clean up and add brackets [ ]  to it.*/
say 'symmetric difference ='   SD                /*display the symmetric difference.    */
                                                 /* [↓]  locate the symmetric AND.      */
   do j=1  for a.1.0;     _=a.1.j                /*process the   A   list names.        */
   if a.1._ & a.2._ & \SA._  then do;   SA._=1   /*if it's common to both, then  ···    */
                                  SA=SA '"'_'",' /*add to symmetric AND  list.          */
                                  end
   end   /*j*/
say                                              /* [↓]  SA ≡  symmetric AND.           */
SA= "["strip( strip(SA), 'T', ",")']'            /*clean up and add brackets [ ]  to it.*/
say '       symmetric AND ='   SA                /*stick a fork in it,  we're all done. */

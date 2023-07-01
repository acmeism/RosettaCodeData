/*REXX program displays a   finite liner combination   in an   infinite vector basis.   */
@.= .;           @.1  =    '  1,  2,  3     '    /*define a specific test case for build*/
                 @.2  =    '  0,  1,  2,  3 '    /*   "   "     "      "    "   "    "  */
                 @.3  =    '  1,  0,  3,  4 '    /*   "   "     "      "    "   "    "  */
                 @.4  =    '  1,  2,  0     '    /*   "   "     "      "    "   "    "  */
                 @.5  =    '  0,  0,  0     '    /*   "   "     "      "    "   "    "  */
                 @.6  =       0                  /*   "   "     "      "    "   "    "  */
                 @.7  =    '  1,  1,  1     '    /*   "   "     "      "    "   "    "  */
                 @.8  =    ' -1, -1, -1     '    /*   "   "     "      "    "   "    "  */
                 @.9  =    ' -1, -2,  0, -3 '    /*   "   "     "      "    "   "    "  */
                 @.10 =      -1                  /*   "   "     "      "    "   "    "  */
  do j=1  while  @.j\==.;        n= 0            /*process each vector; zero element cnt*/
  y= space( translate(@.j, ,',') )               /*elide commas and superfluous blanks. */
  $=                                             /*nullify  output  (liner combination).*/
       do k=1  for words(y);     #= word(y, k)   /* ◄───── process each of the elements.*/
       if #=0  then iterate;     a= abs(# / 1)   /*if the value is zero, then ignore it.*/
       if #<0  then s= '- '                      /*define the sign:   minus (-).        */
               else s= '+ '                      /*   "    "    "     plus  (+).        */
       n= n + 1                                  /*bump the number of elements in vector*/
       if n==1  then s= strip(s)                 /*if the 1st element used, remove blank*/
       if a\==1    then s= s  ||  a'*'           /*if multiplier is unity, then ignore #*/
       $= $  s'e('k")"                           /*construct a liner combination element*/
       end   /*k*/
  $= strip( strip($), 'L', "+")                  /*strip leading plus sign (1st element)*/
  if $==''  then $= 0                            /*handle special case of no elements.  */
  say right( space(@.j), 20)  ' ──► '   strip($) /*align the output for presentation.   */
  end       /*j*/                                /*stick a fork in it,  we're all done. */

/*REXX program to  read/interpret  UPC  symbols and translate them to a numberic string.*/
           #.0= '   ## #'
           #.1= '  ##  #'
           #.2= '  #  ##'
           #.3= ' #### #'
           #.4= ' #   ##'
           #.5= ' ##   #'
           #.6= ' # ####'
           #.7= ' ### ##'
           #.8= ' ## ###'                                /* [↓]  right─sided UPC digits.*/
           #.9= '   # ##' ;        do i=0  for 10;     ##.i= translate(#.i, ' #', "# ")
                                   end  /*i*/
say center('UPC', 14, "─")     '   ---'copies(1234567, 6)"-----"copies(1234567, 6)'---'
@.=.
@.1 = '           # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #         '
@.2 = '          # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         '
@.3 = '           # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         '
@.4 = '         # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #         '
@.5 = '           # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #         '
@.6 = '            # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         '
@.7 = '           # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #         '
@.8 = '          # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         '
@.9 = '           # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #          '
@.10= '          # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### #          '
          ends= '# #'                                        /*define ENDS literal const*/
   do j=1  while @.j\==.;        $= @.j
   txt=                                                      /*initialize  TXT  variable*/
   if left($, 9)\=''     | right($, 9)\=''      then txt= 'bad blanks'
   $= strip($);   $$= $                                      /*elide blanks at ends of $*/
   L= length($)                                              /*obtain length of $ string*/
   if left($, 3) \==ends | right($, 3) \==ends  then txt= 'bad fence'
   if L \== 95           & txt==''              then txt= 'bad length'
   $= substr($, 4, L - length(ends)*2)                                  /*elide "ends". */
   $= delstr($, length($) % 2 - 1,  5)                                  /*  "   middle. */
   sum= 0                                                               /*initialize SUM*/
   if txt==''  then do k=1  for 12;     parse var  $   x  +7  $         /*get UPC digit.*/
                       do d=0  for 10;  if x==#.d | x==##.d  then leave /*valid digit?  */
                       end   /*d*/
                    if d==10 & k \==12  then do;   txt= 'reversed' ;   leave;   end
                    if d==10            then do;   txt= 'bad digit';   leave;   end
                    if k // 2  then sum= sum +    d * 3                 /*mult. by  3.  */
                               else sum= sum +    d                     /*  "    "  1.  */
                    txt= txt  ||  d
                    end     /*k*/

   if left(txt,1)\=="b"  then if sum//10\==0  then txt= 'bad checksum'  /*invalid sum?  */
   say center( strip(txt), 15)  ' '   $$         /*show chksum (or err msg) with the UPC*/
   end   /*j*/                                   /*stick a fork in it,  we're all done. */

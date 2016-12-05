/*REXX program finds the  maximum sum  of a  path of numbers  in a pyramid of numbers.  */
@.=.;                   @.1  =                            55
                        @.2  =                          94 48
                        @.3  =                         95 30 96
                        @.4  =                       77 71 26 67
                        @.5  =                      97 13 76 38 45
                        @.6  =                    07 36 79 16 37 68
                        @.7  =                   48 07 09 18 70 26 06
                        @.8  =                 18 72 79 46 59 79 29 90
                        @.9  =                20 76 87 11 32 07 07 49 18
                        @.10 =              27 83 58 35 71 11 25 57 29 85
                        @.11 =             14 64 36 96 27 11 58 56 92 18 55
                        @.12 =           02 90 03 60 48 49 41 46 33 36 47 23
                        @.13 =          92 50 48 02 36 59 42 79 72 20 82 77 42
                        @.14 =        56 78 38 80 39 75 02 71 66 66 01 03 55 72
                        @.15 =       44 25 67 84 71 67 11 61 40 57 58 89 40 56 36
                        @.16 =     85 32 25 85 57 48 84 35 47 62 17 01 01 99 89 52
                        @.17 =    06 71 28 75 94 48 37 10 23 51 06 48 53 18 74 98 15
                        @.18 =  27 02 92 23 08 71 76 84 15 52 92 63 81 10 44 10 69 93
#.=0
      do    r=1  while  @.r\==.                  /*build another version of the pyramid.*/
         do k=1  for r;    #.r.k=word(@.r, k)    /*assign a number to an array number.  */
         end   /*k*/
      end      /*r*/

      do    r=r-1  by -1  to 2;         p=r-1    /*traipse through the pyramid rows.    */
         do k=1    for p;               _=k+1    /*re─calculate the previous pyramid row*/
         #.p.k=max(#.r.k, #.r._)    +   #.p.k    /*replace the previous number.         */
         end   /*k*/
      end      /*r*/
                                                 /*stick a fork in it,  we're all done. */
say 'maximum path sum: '       #.1.1             /*show the top (row 1) pyramid number. */

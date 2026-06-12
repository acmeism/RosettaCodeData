/*REXX pgm shows overloading of some operators: prefix/addition/subtraction/concatenate.*/
say '──positive prefix──'
say  +5                                          /* positive  prefix integer            */
say  + 5                                         /* positive  prefix integer            */
say  ++6                                         /* positive  prefix integer            */
say  ++ 6                                        /* positive  prefix integer            */
say  +++7                                        /* positive  prefix integer            */
say  +++ 7                                       /* positive  prefix integer            */
say  + + + + 8                                   /* positive  prefix integer            */
say  + (9)                                       /* positive  prefix integer            */

say '──negative prefix──'
say  -1                                          /* negative  prefix integer            */
say  - 1                                         /* negative  prefix integer            */
say  --2                                         /* negative  prefix integer            */
say  -- 2                                        /* negative  prefix integer            */
say  ---3                                        /* negative  prefix integer            */
say  --- 3                                       /* negative  prefix integer            */
say  - - - - 4                                   /* negative  prefix integer            */
say  - (9)                                       /* negative  prefix integer            */

say '───addition───'
say  3     +   5                                 /* integer   plus  integer             */
say  3     +   (5)                               /* integer   plus  integer             */
say  3.0   +   0.5e1                             /* rational  plus  number              */
say '3'    +   5                                 /* string    plus  integer             */
say  3     +  ' 5 '                              /* integer   plus  string              */
say  3     +  '5'                                /* integer   plus  string              */
say '3'    +  '5'                                /* string    plus  string              */
say '3'    +  "5"                                /* string    plus  string              */
say '3.0'  +  '0.5e1'                            /* string    plus  string              */

say '──subtraction──'
say  3     -   5                                 /* integer   minus  integer            */
say  3     -   (5)                               /* integer   minus  integer            */
say  3.0   -   0.5e1                             /* rational  minus  number             */
say '3'    -   5                                 /* string    minus  integer            */
say  3     -  '5'                                /* integer   minus  string             */
say  3     -  ' 5 '                              /* integer   minus  string             */
say '3'    -  '5'                                /* string    minus  string             */
say '3'    -  "5"                                /* string    minus  string             */
say '3.0'  -  '0.5e1'                            /* string    minus  string             */

say '──concatenation──'
say  3     ||   5                                /* integer   concatenated  integer     */
say  3     ||   (5)                              /* integer   concatenated  integer     */
say  3.0   ||   0.5e1                            /* rational  concatenated  number      */
say '3'    ||   5                                /* string    concatenated  integer     */
say  3     ||  '5'                               /* integer   concatenated  string      */
say '3'    ||  '5'                               /* string    concatenated  string      */
say "3"    ||  "5"                               /* string    concatenated  string      */
say '3.0'  | | '0.5e1'                           /* string    concatenated  string      */
say  3     ||  ' 5 '.                            /* integer   concatenated  strings     */

say '────abutment────'
say  3          5                                /* integer   abutted  integer          */
say  3          (5)                              /* integer   abutted  integer          */
say  3.0        0.5e1                            /* rational  abutted  number           */
say '3'         5                                /* string    abutted  integer          */
say  3         '5'                               /* integer   abutted  string           */
say '3'        '5'                               /* string    abutted  string           */
say "3"        "5"                               /* string    abutted  string           */
say  3         ' 5 '.                            /* integer   abutted  strings          */

say '──multiplication──'
say  3     *    5                                /* integer   multiplied  integer       */
say  3     *    (5)                              /* integer   multiplied  integer       */
say  3.0   *    0.5e1                            /* rational  multiplied  number        */
say '3'    *    5                                /* string    multiplied  integer       */
say  3     *   '5'                               /* integer   multiplied  string        */
say '3'    *   '5'                               /* string    multiplied  string        */
say "3"    *   "5"                               /* string    multiplied  string        */
say '3.0'  *   '0.5e1'                           /* string    multiplied  string        */

say '──exponentation──'
say  3     **   5                                /* integer  exponetiated integer       */
say  3     **   (5)                              /* integer  exponetiated integer       */
say  3     * *  5                                /* integer  exponetiated integer       */
say  3.0   **   0.5e1                            /* rational exponetiated number        */
say '3'    **   5                                /* string   exponetiated integer       */
say  3     **  '5'                               /* integer  exponetiated string        */
say '3'    **  '5'                               /* string   exponetiated string        */
say "3"    **  "5"                               /* string   exponetiated string        */
say '3.0'  **  '0.5e1'                           /* string   exponetiated string        */

say '────division────'
say  3     /    5                                /* integer  divided  integer           */
say  3     /    (5)                              /* integer  divided  integer           */
say  3.0   /    0.5e1                            /* rational divided  number            */
say '3'    /    5                                /* string   divided  integer           */
say  3     /   '5'                               /* integer  divided  string            */
say '3'    /   '5'                               /* string   divided  string            */
say "3"    /   "5"                               /* string   divided  string            */
say '3.0'  /   '0.5e1'                           /* string   divided  string            */

say '─────not────'
say  \0                                          /* (not)        invert  binary         */
say  \1                                          /* (not)        invert  binary         */
say  \ 1                                         /* (not)        invert  binary         */
say  \ (0)                                       /* (not)        invert  binary         */
say  \ 1                                         /* (not)        invert  binary         */
say  \ (0)                                       /* (not)        invert  binary         */
say  \\ 0                                        /* (not) (not)  invert  binary         */
say  \ \ 1                                       /* (not) (not)  invert  binary         */

say '─────or─────'
say  0     |    0                                /* binary   OR'ed  binary              */
say  0     |    1                                /* binary   OR'ed  binary              */
say '0'    |   "1"                               /* binary   OR'ed  binary              */
say '1'    |    0                                /* binary   OR'ed  binary              */
say '1'    |   (0)                               /* binary   OR'ed  binary              */

say '─────and────'
say  0     &    0                                /* binary   AND'ed  binary             */
say  0     &    1                                /* binary   AND'ed  binary             */
say '0'    &   "1"                               /* binary   AND'ed  binary             */
say '1'    &    0                                /* binary   AND'ed  binary             */
say '1'    &   (0)                               /* binary   AND'ed  binary             */

say '─────XOR────'
say  0     &&    0                               /* binary   XOR'ed  binary             */
say  0     &&    1                               /* binary   XOR'ed  binary             */
say '0'    &&   "1"                              /* binary   XOR'ed  binary             */
say '1'    &&    0                               /* binary   XOR'ed  binary             */
say '1'    &&   (0)                              /* binary   XOR'ed  binary             */

exit 0                                           /*stick a fork in it,  we're all done. */

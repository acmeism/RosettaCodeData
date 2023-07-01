/*REXX pgm reads fixed─length 80 byte records;  reverses each record, displays to term. */
iFID= 'FIXEDLEN.TXT'                             /*the file's filename (used for input).*/
call charin iFID, 1, 0                           /*open the file, point rec pointer to 1*/
                                                 /* [+]  just to be safe, position file.*/
            do j=1  while chars(iFID) >= 80      /*read data records of LRECL ≡ eighty. */
            @.j= charin(iFID, , 80)              /*read a data record of eighty bytes.  */
            end   /*j*/
#= j - 1                                         /*adjust # of records (J is 1 too high)*/
            do k=1  for #                        /* [↓]  process all the records read.  */
            say reverse(@.k)                     /* reverse a record and write to term. */
            end   /*k*/                          /*stick a fork in it,  we're all done. */

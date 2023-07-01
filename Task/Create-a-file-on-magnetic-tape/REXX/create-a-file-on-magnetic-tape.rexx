/*REXX pgm  demonstrates  writing records  to an attached magnetic tape.*/
dsName = 'TAPE.FILE'                   /*dsName of "file" being written.*/

          do j=1  for 100              /*write 100 records to mag tape. */
          call lineout  dsName,  'this is record'   j   ||   "."
          end   /*j*/
                                       /*stick a fork in it, we're done.*/

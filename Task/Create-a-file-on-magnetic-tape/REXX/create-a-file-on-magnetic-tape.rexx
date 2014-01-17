/*REXX pgm  demonstrates  writing records  to an attached magnetic tape.*/
/* The actual mounting & attaching would be performed by the appropriate*/
/* operating system (and/or user) commands.   DSNAME  (below)  would be */
/* the REXX variable that is associated with a dataset that is assigned */
/* to a magnetic tape device.   The association would be different,     */
/* depending on upon the operating system being used.  VM/CMS would use */
/* a   CP ATTACH   command, coupled with a   CMS FILEDEF   command which*/
/* associates a DSNAME  (dataset name)  that will be written to on the  */
/* attached  (and mounted)  magnetic tape device.                       */

dsName = 'TAPE.FILE'                   /*dsName of "file" being written.*/

          do j=1  for 100              /*write 100 records to mag tape. */
          call lineout  dsName,  'this is record'   j   ||   "."
          end   /*j*/
                                       /*stick a fork in it, we're done.*/

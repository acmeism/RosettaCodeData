/*REXX program to read a file containing a list of earthquakes:   date, site, magnitude.*/
parse arg iFID mMag .                            /*obtain optional arguments from the CL*/
if iFID=='' | iFID==","  then iFID= 'earthquakes.dat' /*Not specified?  Then use default*/
if mMag=='' | mMag==","  then mMag= 6                 /* "      "         "   "     "   */
#=0                                              /*# of earthquakes that meet criteria. */
   do j=0  while lines(iFID)\==0                 /*read all lines in the input file.    */
   if j==0  then say 'Reading from file: ' iFID  /*show the name of the file being read.*/
   parse value linein(iFID) with date site mag . /*parse three words from an input line.*/
   if mag<=mMag  then iterate                    /*Is the quake too small?  Then skip it*/
   #= # + 1;     if j==0  then say               /*bump the number of qualifying quakes.*/
   if #==1  then say center('date', 20, "═")     '=magnitude='     center("site", 20, '═')
   say               center(date, 20)      center(mag/1, 11)   '  '        site
   end   /*j*/                                   /*stick a fork in it,  we're all done. */
say
say
if j\==0  then say j  'records read from file: ' iFID
say
if j==0  then say er 'file    '          iFID           "   is empty or not found."
         else say #  ' earthquakes listed whose magnitude is  ≥ ' mMag

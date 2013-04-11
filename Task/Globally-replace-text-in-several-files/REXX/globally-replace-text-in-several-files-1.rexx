/*REXX program to read the files specified and globally replace a string*/
old = 'Goodbye London!'                /*old text to be replaced.       */
new = 'Hello New York!'                /*new text used for replacement. */
parse arg fileList;       files=words(fileList);           pad=left('',20)
                                       hdr='────── file'   /*eyecatcher.*/
   do f=1  for files;     aFile=translate(word(fileList,f),,','); say; say
   say hdr' is being read: '  aFile  pad  "("f  'out of'  files  "files)."
   call linein aFile,1,0               /*position the file for input.   */
   changes=0                           /*# changes in the file (so far).*/

      do j=1  while lines(aFile)\==0   /*read a file  (if it exists).   */
      @.j = linein(aFile)              /*read a record from the file.   */
      if pos(old,@.j)==0  then iterate /*Anything to change?   No, skip.*/
      changes = changes+1              /*bump the change counter.       */
      @.j = changestr(old,@.j,new)     /*change this record, old ──► new*/
      end   /*j*/

   say hdr '     was read: '   aFile", with "   j-1   'records.'
   if  changes == 0  then  do
                           say hdr ' not  changed: ' aFile
                           iterate  /*f*/
                           end
   call lineout aFile,,1               /*position the file for output.  */
   say hdr 'being changed: ' aFile
     do r=1 for j-1;  call lineout aFile,@.r;  end      /*re-write file.*/
   say hdr 'was   changed: ' aFile  " with" changes 'lines changed.'
   end   /*f*/
                                       /*stick a fork in it, we're done.*/

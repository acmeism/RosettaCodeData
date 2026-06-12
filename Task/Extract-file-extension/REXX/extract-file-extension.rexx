/*REXX pgm extracts the file extension (defined above from the RC task) from a file name*/
@.=                                              /*define default value for the @ array.*/
parse arg fID                                    /*obtain any optional arguments from CL*/
if fID\==''  then @.1 = fID                      /*use the  filename  from the C.L.     */
             else do                             /*No filename given? Then use defaults.*/
                  @.1 = 'http://example.com/download.tar.gz'
                  @.2 = 'CharacterModel.3DS'
                  @.3 = '.desktop'
                  @.4 = 'document'
                  @.5 = 'document.txt_backup'
                  @.6 = '/etc/pam.d/login'
                  end

   do j=1  while  @.j\=='';     x=               /*process  (all of)  the file name(s). */
   p=lastpos(., @.j)                             /*find the last position of a period.  */
   if p\==0  then x=substr(@.j, p+1)             /*Found a dot?  Then get stuff after it*/
   if \datatype(x, 'A')   then x=                /*Not upper/lowercase letters | digits?*/
   if x==''  then x= " [null]"                   /*use a better name for a  "null"  ext.*/
             else x= . || x                      /*prefix the extension with a  period. */
   say 'file extension='       left(x, 20)     "for file name="         @.j
   end       /*j*/                               /*stick a fork in it,  we're all done. */

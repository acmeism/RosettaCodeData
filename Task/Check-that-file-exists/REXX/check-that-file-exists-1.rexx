/*REXX program creates a new empty file and directory in current directory and root dir.*/
fn= 'input.txt'                                  /*default name of a file.              */
dn= 'docs'                                       /*default name of a directory (folder).*/
@.1= 'current directory';  @.2= 'root directory' /*messages used to indicate which pass.*/
parse upper version v                            /*obtain name of the REXX being used.  */
regina= pos('REGINA'  , v)\==0                   /*is this the Regina REXX being used?  */
r4    = pos('REXX-R4' , v)\==0                   /*is this the R4     REXX being used?  */
@doesnt= "doesn't exist in the"
@does  = "does exist in the"

 do j=1  for 2;    say                           /* [↑]  perform these statements twice.*/
 if stream(fn, 'C', "QUERY EXISTS")==''  then say 'file '       fn   @doesnt   @.j
                                         else say 'file '       fn   @does     @.j

 if j==2  then iterate
 if stream(dn, 'C', "QUERY EXISTS")==''  then say 'directory'   dn   @doesnt   @.j
                                         else say 'directory'   dn   @does     @.j
 if j==1  then select
               when regina  then call chdir    '\'    /*use Regina's version of  CHDIR. */
               when r4      then call stream   '\', "C", 'CHDIR'        /*R4's version. */
               otherwise         call doschdir '\'    /*PC/REXX & Personal REXX version.*/
               end   /*select*/
 end   /*j*/                                     /*stick a fork in it,  we're all done. */

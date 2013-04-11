/*REXX program finds  common directory path  for a list of files.       */
@.=                                    /*define all file lists to null. */
@.1 = '/home/user1/tmp/coverage/test'
@.2 = '/home/user1/tmp/covert/operator'
@.3 = '/home/user1/tmp/coven/members'
L=length(@.1)
                do j=2  while @.j\=='' /*start with the second string.  */
                _ = compare(@.j,@.1);  if _==0  then iterate    /*equal.*/
                L = min(L,_)           /*find the minimum equal strings.*/
                end   /*j*/

common = left(@.1,lastpos('/',@.1,L))  /*find the shortest  DIR  string.*/
if right(common,1)=='/'  then common=left(common, max(0,length(common)-1))
say 'common directory path: ' common   /*[↑] handle trailing / delimiter*/
                                       /*stick a fork in it, we're done.*/

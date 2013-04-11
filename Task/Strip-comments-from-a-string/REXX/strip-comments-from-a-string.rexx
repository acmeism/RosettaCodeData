/*REXX program strips a string delinated by a hash (#) or semicolon (;).*/
old1=' apples, pears # and bananas' ; say '            old ───►'old1"◄───"
new1=stripCom1(old1)                ; say '1st version new ───►'new1"◄───"
new2=stripCom2(old1)                ; say '2nd version new ───►'new2"◄───"
new3=stripCom3(old1)                ; say '3rd version new ───►'new3"◄───"
new4=stripCom3(old1)                ; say '4th version new ───►'new4"◄───"
                                      say  copies('═',55)
old2=' apples, pears ; and bananas' ; say '            old ───►'old2"◄───"
new1=stripCom1(old2)                ; say '1st version new ───►'new1"◄───"
new2=stripCom2(old2)                ; say '2nd version new ───►'new2"◄───"
new3=stripCom3(old2)                ; say '3rd version new ───►'new3"◄───"
new4=stripCom3(old2)                ; say '4th version new ───►'new4"◄───"
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────STRIPCOM1 subroutine────────────────*/
stripCom1:  procedure;   parse arg x   /*get the argument  (string).    */
x=translate(x,'#',";")                 /*translate  semicolons to hash. */
parse var x x '#'                      /*parse string,  ending in hash. */
return strip(x)                        /*return striped shortened string*/
/*──────────────────────────────────STRIPCOM2 subroutine────────────────*/
stripCom2:  procedure;   parse arg x   /*get the argument  (string).    */
d='#;'                                 /*delimiter list to be used.     */
d1=left(d,1)                           /*get the 1st character in delim.*/
x=translate(x,copies(d1,length(d)),d)  /*trans all delims ──► 1st delim.*/
parse var x x (d1)                     /*parse string,  ending in hash. */
return strip(x)                        /*return striped shortened string*/
/*──────────────────────────────────STRIPCOM3 subroutine────────────────*/
stripCom3:  procedure;   parse arg x   /*get the argument  (string).    */
d=';#'                                 /*delimiter list to be used.     */
                do j=1 for length(d)   /*process each delimiter singly. */
                _=substr(d,j,1)        /*use one delimiter at a time.   */
                parse var x x (_)      /*parse X string for each delim. */
                end   /*j*/
return strip(x)                        /*return striped shortened string*/
/*──────────────────────────────────STRIPCOM4 subroutine────────────────*/
stripCom4:  procedure;   parse arg x   /*get the argument  (string).    */
d=';#'                                 /*delimiter list to be used.     */
                do k=1 for length(d)   /*process each delimiter singly. */
                p=pos(substr(d,k,1),x) /*see if a delimiter is in  X.   */
                if p\==0 then x=left(x,p-1)    /*shorten the  X  string.*/
                end   /*k*/
return strip(x)                        /*return striped shortened string*/

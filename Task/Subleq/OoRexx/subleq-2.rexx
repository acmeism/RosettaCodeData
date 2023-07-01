/*REXX program simulates execution of a  One-Instruction Set Computer (OISC). */
Signal on Halt                         /*enable user to halt the simulation.  */
cell=.array~new                        /*zero-out all of real memory locations*/
ip=0                                   /*initialize ip  (instruction pointer).*/
Parse Arg memory                       /*get optional low memory vals from CL.*/
memory=space(memory)                   /*elide superfluous blanks from string.*/

if memory==''  then Do
  memory='15 17 -1 17 -1 -1 16 1 -1 16 3 -1 15 15 0 0 -1' /* common start     */
  If 3=="f3"x  then                    /* EBCDIC                              */
    memory=memory '200 133 147 147 150 107 64 166 150 153 147 132  90  21 0'
  else /* ASCII      H   e   l   l   o   , bla  w   o   r   l   d   ! l/f */
    memory=memory ' 72 101 108 108 111  44 32 119 111 114 108 100  33  10 0'
  End

Do i=1 To words(memory)               /* copy memory to cells                */
  cell[i]=word(memory,i)
  End

Do Until ip<0                          /* [?]  neg addresses are treated as -1*/
  a=cell[ip+1]
  b=cell[ip+2]
  c=cell[ip+3]                         /*get values for  A,  B,  and  C.      */
  ip=ip+3                              /*advance the ip (instruction pointer).*/
  Select                               /*choose an instruction state.         */
    When a<0   then cell[b+1]=charin()           /* read a character from term*/
    When b<0   then call charout ,d2c(cell[a+1]) /* write "    "      to    " */
    Otherwise Do
      cell[b+1]-=cell[a+1]             /* put difference ---? loc  B[         */
      If cell[b+1]<=0  Then ip=c       /* if ¬positive, set ip to  C[         */
      End
    End
  End
Exit
halt: Say 'REXX program halted by user.';
      Exit 1

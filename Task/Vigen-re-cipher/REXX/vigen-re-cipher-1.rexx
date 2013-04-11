/*REXX program encrypts uppercased text using the  Vigenère  cypher.    */
@.1 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
L=length(@.1)
                         do j=2 to L;    jm=j-1;    q=@.jm
                         @.j=substr(q,2,L-1)left(q,1)
                         end   /*j*/

cypher = space('WHOOP DE DOO    NO BIG DEAL HERE OR THERE',0)
oMsg   = 'People solve problems by trial and error; judgement helps pick the trial.'
oMsgU  = oMsg;    upper oMsgU
cypher_=copies(cypher,length(oMsg)%length(cypher))
say '   original text =' oMsg
                         xMsg=Ncypher(oMsgU)
say '   cyphered text =' xMsg
                         bMsg=Dcypher(xMsg)
say 're-cyphered text =' bMsg
exit
/*───────────────────────────────Ncypher subroutine─────────────────────*/
Ncypher:  parse arg stuff;     #=1;   nMsg=
   do i=1 for length(stuff);   x=substr(stuff,i,1)    /*pick off 1 char.*/
   if \datatype(x,'U') then iterate    /*not a letter?   Then ignore it.*/
   j=pos(x,@.1);   nMsg=nMsg || substr(@.j,pos(substr(cypher_,#,1),@.1),1)
   #=#+1                               /*bump the character counter.    */
   end
return nMsg
/*───────────────────────────────Dcypher subroutine──────────────────────*/
Dcypher:  parse arg stuff;     #=1;   dMsg=
   do i=1 for length(stuff);   x=substr(cypher_,i,1)  /*pick off 1 char.*/
   j=pos(x,@.1);   dMsg=dMsg || substr(@.1, pos(substr(stuff,i,1),@.j),1)
   end
return dMsg

/*REXX program  encrypts  (and displays)  uppercased text  using  the  Vigenère  cypher.*/
@.1 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
L=length(@.1)
                         do j=2  to L;                        jm=j-1;    q=@.jm
                         @.j=substr(q, 2, L - 1)left(q, 1)
                         end   /*j*/

cypher = space('WHOOP DE DOO    NO BIG DEAL HERE OR THERE', 0)
oMsg   = 'People solve problems by trial and error; judgement helps pick the trial.'
oMsgU  = oMsg;    upper oMsgU
cypher_= copies(cypher, length(oMsg) % length(cypher) )
                                say '   original text ='   oMsg
   xMsg= Ncypher(oMsgU);        say '   cyphered text ='   xMsg
   bMsg= Dcypher(xMsg) ;        say 're-cyphered text ='   bMsg
exit
/*──────────────────────────────────────────────────────────────────────────────────────*/
Ncypher:  parse arg x;    nMsg=;       #=1      /*unsupported char? ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓*/
              do i=1  for length(x);   j=pos(substr(x,i,1), @.1);   if j==0  then iterate
              nMsg=nMsg || substr(@.j, pos( substr( cypher_, #, 1), @.1), 1);     #=#+1
              end   /*j*/
          return nMsg
/*──────────────────────────────────────────────────────────────────────────────────────*/
Dcypher:  parse arg x;    dMsg=
              do i=1  for length(x);   j=pos(substr(cypher_, i, 1),  @.1)
              dMsg=dMsg || substr(@.1, pos( substr(x, i, 1), @.j),   1  )
              end   /*j*/
          return dMsg

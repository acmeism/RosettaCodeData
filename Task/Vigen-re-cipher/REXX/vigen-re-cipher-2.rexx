/*REXX program  encrypts  (and displays)  most text  using  the  Vigenère  cypher.      */
@abc= 'abcdefghijklmnopqrstuvwxyz';       @abcU=@abc;    upper @abcU
@.1 = @abcU || @abc'0123456789~`!@#$%^&*()_-+={}|[]\:;<>?,./" '''
L=length(@.1)
                         do j=2  to length(@.1);                jm=j-1;   q=@.jm
                         @.j=substr(q, 2, L-1)left(q, 1)
                         end   /*j*/

cypher = space('WHOOP DE DOO    NO BIG DEAL HERE OR THERE', 0)
oMsg   = 'Making things easy is just knowing the shortcuts. --- Gerard J. Schildberger'
cypher_= copies(cypher, length(oMsg) % length(cypher) )
say '   original text =' oMsg
                         xMsg=Ncypher(oMsg)
say '   cyphered text =' xMsg
                         bMsg=Dcypher(xMsg)
say 're-cyphered text =' bMsg
exit
/*──────────────────────────────────────────────────────────────────────────────────────*/
Ncypher:  parse arg x;    nMsg=;       #=1      /*unsupported char? ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓*/
              do i=1  for length(x);   j=pos(substr(x,i,1), @.1);   if j==0  then iterate
              nMsg=nMsg || substr(@.j, pos( substr( cypher_, #, 1), @.1), 1);     #=#+1
              end   /*j*/
          return nMsg
/*──────────────────────────────────────────────────────────────────────────────────────*/
Dcypher:  parse arg x;    dMsg=
              do i=1  for length(x);   j=pos(substr(cypher_, i, 1), @.1)
              dMsg=dMsg || substr(@.1, pos( substr(x, i, 1), @.j), 1)
              end   /*j*/
          return dMsg

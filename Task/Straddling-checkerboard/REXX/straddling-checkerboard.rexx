/*REXX program uses the  straddling checkerboard  cipher to encrypt/decrypt a message.  */
parse arg msg                                    /*obtain optional message from the C.L.*/
if msg=''  then msg= 'One night-it was the twentieth of March, 1888-I was returning'
                      say 'plain text='  msg
call genCipher  'et aon ris',  'bcdfghjklm',  'pq/uvwxyz.'    /*build the cipher (board)*/
enc= encrypt(msg);     say ' encrypted='  enc    /*encrypt message and show encryption. */
dec= decrypt(enc);     say ' decrypted='  dec    /*decrypt    "     "    "  decryption. */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
genCipher: @.=;   arg @..,two,three;    z= -1;  @.z= @..      /*build top row of cipher.*/
           _= pos(' ', @..     )  - 1;  @._= two              /*  "   2nd  "   "    "   */
           _= pos(' ', @.., _+2)  - 1;  @._= three            /*  "   3rd  "   "    "   */
             do j=0  for 9;    @..= @.. || @.j   /*construct a table for fast searching.*/
             if @.j\==''  then @.r= @.r || j
             _= pos('/', @.j)                    /*is the escape character in this row? */
             if _\==0  then @.dig= j || (_-1)    /*define    "       "     for numerals.*/
             end   /*j*/
           @..= space(@.., 0);       return      /*purify the table of encryptable chars*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
encrypt: procedure expose @.;  arg !,,$          /*$:  output  (encrypted text)  so far.*/
           do j=1  for length(!)                 /*process each of the plain─text chars.*/
           x= substr(!, j, 1)                    /*obtain a message char to be encrypted*/
           if datatype(x, 'W')  then do;  $= $ || @.dig || x;  iterate;  end  /*numeral?*/
           if pos(x, @..)==0    then iterate     /*Not one of the allowable chars?  Skip*/
              do k=-1  for 10;  y= pos(x, @.k)   /*traipse thru rows, looking for match.*/
              if y==0           then iterate     /*Not in this row?   Then keep looking.*/
              z= k;   if z==-1  then z=          /*construct the index of the cypher row*/
              $= $  ||  z  ||  (y-1);  leave     /*add an encrypted character to output.*/
              end   /*k*/
           end      /*j*/;      return $
/*──────────────────────────────────────────────────────────────────────────────────────*/
decrypt: procedure expose @.;     parse arg !,,$ /*$:  output  (decrypted text)  so far.*/
           do j=1  to length(!);    rw= -1       /*process each of the encypted numbers.*/
           x= substr(!,j,1)                      /*obtain a message char to be decrypted*/
           if substr(!,j,2)==@.dig  then do; j= j+2; $= $ || substr(!, j, 1); iterate; end
           if pos(x, @.r)\==0       then do; j= j+1; rw=x; x=substr(!, j, 1);          end
           $= $ || substr(@.rw, x+1, 1)          /*add a character to decrypted message.*/
           end   /*j*/;             return $

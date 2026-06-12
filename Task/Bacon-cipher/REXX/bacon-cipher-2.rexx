/*REXX program implements and demonstrates a (full)  "Bacon"  cipher (cypher).*/
parse arg plain                        /*obtain optional arguments from the CL*/
if plain=''  then plain =  "The quick brown fox jumped over the lazy dog."
                                       /*alphabet must be in uppercase letters*/
alphabet= 'ABCDEFGHIJKLMNOPQRSTUVWXYZ .,?!:'  /*list of letters & punctuation.*/
@.=                                           /*assign a default for all chars*/
     do j=0  for min(32,length(alphabet));              _=substr(alphabet,j+1,1)
     @._=translate(right(x2b(d2x(j)), 5, 0),  '┴┬', 01)
     end   /*j*/                       /* [↑]  build the symbol table (max=32)*/
                                       /* [↑]  code supports some punctuation.*/
say ' plain text: '    plain           /*display the original  (plain)  text. */
      encoded=BaconEnc(plain)          /*encode using a (full)  Bacon  cipher.*/
say 'cipher text: '    encoded         /*display the ciphered  (coded)  text. */
      decoded=BaconDec(encoded)        /*decode ciphered text──►plain (almost)*/
say 'cycled text: '    decoded         /*display the recycled text  (~ plain),*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
BaconEnc: procedure expose @.;        arg x;                $=;     Lx=length(x)
            do j=1  for Lx;           _=substr(x,j,1);      $=$ || @._;      end
          return $
/*────────────────────────────────────────────────────────────────────────────*/
BaconDec: procedure expose @.;        parse arg x;          $=;     Lx=length(x)
            do k=0 for 256; _=d2c(k); if @._=='' then iterate; q=@._; !.q=_; end
            do j=1  to Lx  by 5;      y=substr(x,j,5);      $=$ || !.y;      end
          return $

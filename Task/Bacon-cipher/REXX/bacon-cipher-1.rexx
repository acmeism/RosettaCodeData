/*REXX program implements and demonstrates a (full)  "Bacon"  cipher (cypher).*/
parse arg plain                        /*obtain optional arguments from the CL*/
if plain=''  then plain =  "The quick brown fox jumped over the lazy dog."
                                       /* [↓]  code supports complete alphabet*/
@.=; @.a=11111; @.b=11110; @.c=11101; @.d=11100; @.e=11011; @.f=11010; @.g=11001
     @.h=11000; @.i=10111; @.j=00111; @.k=10110; @.l=10101; @.m=10100; @.n=10011
     @.o=10010; @.p=10001; @.q=10000; @.r=01111; @.s=01110; @.t=01101; @.u=01100
     @.v=00100; @.w=01011; @.x=01010; @.y=01001; @.z=01000; @.?=00000; @.!=00101
     @..=00110;   _=','  ; @._=00001;   _=' '  ; @._=00011;   _=':'  ; @._=00010
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

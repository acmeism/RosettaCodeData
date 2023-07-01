/*REXX pgm computes&displays X n-smooth numbers; both X and N can be specified as ranges*/
numeric digits 200                               /*be able to handle some big numbers.  */
parse arg LOx HIx LOn HIn .                      /*obtain optional arguments from the CL*/
if LOx=='' | LOx==","  then LOx=  1              /*Not specified?  Then use the default.*/
if HIx=='' | HIx==","  then HIx= LOx + 24        /* "      "         "   "   "     "    */
if LOn=='' | LOn==","  then LOn=  2              /* "      "         "   "   "     "    */
if HIn=='' | HIn==","  then HIn= LOn + 27        /* "      "         "   "   "     "    */
call genP HIn                                    /*generate enough primes to satisfy HIn*/
@aList= ' a list of the ';              @thru= ' through '  /*literals used with a  SAY.*/

     do j=LOn  to  HIn;  if !.j==0  then iterate /*if not prime, then skip this number. */
     call smooth HIx,j;                 $=       /*invoke SMOOTH; initialize $  (list). */
                     do k=LOx  to HIx;  $= $ #.k /*append a  smooth number to  "  "   " */
                     end   /*k*/
     say center(@aList  th(LOx)  @thru  th(HIx)     ' numbers for' j"-smooth ",  130, "═")
     say strip($);                      say
     end   /*j*/                                 /* [↑]  the $ list has a leading blank.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP: procedure expose @. !. #; parse arg x      /*#≡num of primes; @. ≡array of primes.*/
      @.=;      @.1=2; @.2=3; @.3=5; @.4=7; @.5=11; @.6=13; @.7=17; @.8=19; @.9=23;    #=9
      !.=0;     !.2=1; !.3=2; !.5=3; !.7=4; !.11=5; !.13=6; !.17=7; !.19=8; !.23=9
           do k=@.#+6  by 2  until #>=x ;        if k//3==0    then iterate
           parse var  k  ''  -1  _;              if _==5       then iterate
                        do d=4  until @.d**2>k;  if k//@.d==0  then iterate k
                        end   /*d*/
           #= # + 1;    !.k= #;       @.#= k     /*found a prime, bump counter; assign @*/
           end  /*k*/;                return
/*──────────────────────────────────────────────────────────────────────────────────────*/
smooth: procedure expose @. !. #.; parse arg y,p /*obtain the arguments from the invoker*/
        if p==''  then p= 3                      /*Not specified? Then assume Hamming #s*/
        n= !.p                                   /*the number of primes being used.     */
        nn= n - 1;            #.=  0;    #.1= 1  /*an array of n-smooth numbers (so far)*/
        f.=  1                                   /*the indices of factors of a number.  */
                do j=2  for y-1;              _= f.1
                z= @.1 * #._
                             do k=2  for nn;  _= f.k;  v= @.k * #._;    if v<z  then z= v
                             end   /*k*/
                #.j= z
                             do d=1  for n;   _= f.d;  if @.d * #._==z  then f.d= f.d + 1
                             end   /*d*/
                end   /*j*/;                  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
th: parse arg th; return th || word('th st nd rd', 1+(th//10)*(th//100%10\==1)*(th//10<4))

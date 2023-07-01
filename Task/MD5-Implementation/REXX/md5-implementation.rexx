/*REXX program tests the MD5 procedure (below) as per a test suite from IETF RFC (1321).*/
@.1 =                                            /*─────MD5 test suite [from above doc].*/
@.2 = 'a'
@.3 = 'abc'
@.4 = 'message digest'
@.5 = 'abcdefghijklmnopqrstuvwxyz'
@.6 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
@.7 =  12345678901234567890123456789012345678901234567890123456789012345678901234567890
@.0 = 7                                          /* [↑]  last value doesn't need quotes.*/
                do m=1  for  @.0;         say    /*process each of the seven messages.  */
                say ' in ='  @.m                 /*display the      in      message.    */
                say 'out ='  MD5(@.m)            /*   "     "       out        "        */
                end   /*m*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
MD5: procedure; parse arg !;  numeric digits 20  /*insure there's enough decimal digits.*/
     a= '67452301'x;         b= "efcdab89"x;         c= '98badcfe'x;        d= "10325476"x
     #= length(!)                                /*length in bytes of the input message.*/
     L= #*8//512;   if L<448  then plus= 448 - L /*is the length  less   than  448 ?    */
                    if L>448  then plus= 960 - L /* "  "     "   greater   "    "       */
                    if L=448  then plus= 512     /* "  "     "    equal   to    "       */
                                                 /* [↓]  a little of this, ···          */
     $=! || "80"x || copies('0'x,plus%8-1)reverse(right(d2c(8*#), 4, '0'x)) || '00000000'x
                                                 /* [↑]       ···  and a little of that.*/
         do j=0  for length($) % 64              /*process the message  (lots of steps).*/
         a_= a;     b_= b;     c_= c;      d_= d /*save the  original values  for later.*/
         chunk= j * 64                           /*calculate the  size  of the chunks.  */
                       do k=1  for 16            /*process the message in chunks.       */
                       !.k= reverse( substr($, chunk + 1 + 4*(k-1), 4) )  /*magic stuff.*/
                       end   /*k*/                                        /*────step────*/
         a  =  .p1( a,   b,   c,   d,    0,    7,   3614090360)           /*■■■■  1 ■■■■*/
         d  =  .p1( d,   a,   b,   c,    1,   12,   3905402710)           /*■■■■  2 ■■■■*/
         c  =  .p1( c,   d,   a,   b,    2,   17,    606105819)           /*■■■■  3 ■■■■*/
         b  =  .p1( b,   c,   d,   a,    3,   22,   3250441966)           /*■■■■  4 ■■■■*/
         a  =  .p1( a,   b,   c,   d,    4,    7,   4118548399)           /*■■■■  5 ■■■■*/
         d  =  .p1( d,   a,   b,   c,    5,   12,   1200080426)           /*■■■■  6 ■■■■*/
         c  =  .p1( c,   d,   a,   b,    6,   17,   2821735955)           /*■■■■  7 ■■■■*/
         b  =  .p1( b,   c,   d,   a,    7,   22,   4249261313)           /*■■■■  8 ■■■■*/
         a  =  .p1( a,   b,   c,   d,    8,    7,   1770035416)           /*■■■■  9 ■■■■*/
         d  =  .p1( d,   a,   b,   c,    9,   12,   2336552879)           /*■■■■ 10 ■■■■*/
         c  =  .p1( c,   d,   a,   b,   10,   17,   4294925233)           /*■■■■ 11 ■■■■*/
         b  =  .p1( b,   c,   d,   a,   11,   22,   2304563134)           /*■■■■ 12 ■■■■*/
         a  =  .p1( a,   b,   c,   d,   12,    7,   1804603682)           /*■■■■ 13 ■■■■*/
         d  =  .p1( d,   a,   b,   c,   13,   12,   4254626195)           /*■■■■ 14 ■■■■*/
         c  =  .p1( c,   d,   a,   b,   14,   17,   2792965006)           /*■■■■ 15 ■■■■*/
         b  =  .p1( b,   c,   d,   a,   15,   22,   1236535329)           /*■■■■ 16 ■■■■*/
         a  =  .p2( a,   b,   c,   d,    1,    5,   4129170786)           /*■■■■ 17 ■■■■*/
         d  =  .p2( d,   a,   b,   c,    6,    9,   3225465664)           /*■■■■ 18 ■■■■*/
         c  =  .p2( c,   d,   a,   b,   11,   14,    643717713)           /*■■■■ 19 ■■■■*/
         b  =  .p2( b,   c,   d,   a,    0,   20,   3921069994)           /*■■■■ 20 ■■■■*/
         a  =  .p2( a,   b,   c,   d,    5,    5,   3593408605)           /*■■■■ 21 ■■■■*/
         d  =  .p2( d,   a,   b,   c,   10,    9,     38016083)           /*■■■■ 22 ■■■■*/
         c  =  .p2( c,   d,   a,   b,   15,   14,   3634488961)           /*■■■■ 23 ■■■■*/
         b  =  .p2( b,   c,   d,   a,    4,   20,   3889429448)           /*■■■■ 24 ■■■■*/
         a  =  .p2( a,   b,   c,   d,    9,    5,    568446438)           /*■■■■ 25 ■■■■*/
         d  =  .p2( d,   a,   b,   c,   14,    9,   3275163606)           /*■■■■ 26 ■■■■*/
         c  =  .p2( c,   d,   a,   b,    3,   14,   4107603335)           /*■■■■ 27 ■■■■*/
         b  =  .p2( b,   c,   d,   a,    8,   20,   1163531501)           /*■■■■ 28 ■■■■*/
         a  =  .p2( a,   b,   c,   d,   13,    5,   2850285829)           /*■■■■ 29 ■■■■*/
         d  =  .p2( d,   a,   b,   c,    2,    9,   4243563512)           /*■■■■ 30 ■■■■*/
         c  =  .p2( c,   d,   a,   b,    7,   14,   1735328473)           /*■■■■ 31 ■■■■*/
         b  =  .p2( b,   c,   d,   a,   12,   20,   2368359562)           /*■■■■ 32 ■■■■*/
         a  =  .p3( a,   b,   c,   d,    5,    4,   4294588738)           /*■■■■ 33 ■■■■*/
         d  =  .p3( d,   a,   b,   c,    8,   11,   2272392833)           /*■■■■ 34 ■■■■*/
         c  =  .p3( c,   d,   a,   b,   11,   16,   1839030562)           /*■■■■ 35 ■■■■*/
         b  =  .p3( b,   c,   d,   a,   14,   23,   4259657740)           /*■■■■ 36 ■■■■*/
         a  =  .p3( a,   b,   c,   d,    1,    4,   2763975236)           /*■■■■ 37 ■■■■*/
         d  =  .p3( d,   a,   b,   c,    4,   11,   1272893353)           /*■■■■ 38 ■■■■*/
         c  =  .p3( c,   d,   a,   b,    7,   16,   4139469664)           /*■■■■ 39 ■■■■*/
         b  =  .p3( b,   c,   d,   a,   10,   23,   3200236656)           /*■■■■ 40 ■■■■*/
         a  =  .p3( a,   b,   c,   d,   13,    4,    681279174)           /*■■■■ 41 ■■■■*/
         d  =  .p3( d,   a,   b,   c,    0,   11,   3936430074)           /*■■■■ 42 ■■■■*/
         c  =  .p3( c,   d,   a,   b,    3,   16,   3572445317)           /*■■■■ 43 ■■■■*/
         b  =  .p3( b,   c,   d,   a,    6,   23,     76029189)           /*■■■■ 44 ■■■■*/
         a  =  .p3( a,   b,   c,   d,    9,    4,   3654602809)           /*■■■■ 45 ■■■■*/
         d  =  .p3( d,   a,   b,   c,   12,   11,   3873151461)           /*■■■■ 46 ■■■■*/
         c  =  .p3( c,   d,   a,   b,   15,   16,    530742520)           /*■■■■ 47 ■■■■*/
         b  =  .p3( b,   c,   d,   a,    2,   23,   3299628645)           /*■■■■ 48 ■■■■*/
         a  =  .p4( a,   b,   c,   d,    0,    6,   4096336452)           /*■■■■ 49 ■■■■*/
         d  =  .p4( d,   a,   b,   c,    7,   10,   1126891415)           /*■■■■ 50 ■■■■*/
         c  =  .p4( c,   d,   a,   b,   14,   15,   2878612391)           /*■■■■ 51 ■■■■*/
         b  =  .p4( b,   c,   d,   a,    5,   21,   4237533241)           /*■■■■ 52 ■■■■*/
         a  =  .p4( a,   b,   c,   d,   12,    6,   1700485571)           /*■■■■ 53 ■■■■*/
         d  =  .p4( d,   a,   b,   c,    3,   10,   2399980690)           /*■■■■ 54 ■■■■*/
         c  =  .p4( c,   d,   a,   b,   10,   15,   4293915773)           /*■■■■ 55 ■■■■*/
         b  =  .p4( b,   c,   d,   a,    1,   21,   2240044497)           /*■■■■ 56 ■■■■*/
         a  =  .p4( a,   b,   c,   d,    8,    6,   1873313359)           /*■■■■ 57 ■■■■*/
         d  =  .p4( d,   a,   b,   c,   15,   10,   4264355552)           /*■■■■ 58 ■■■■*/
         c  =  .p4( c,   d,   a,   b,    6,   15,   2734768916)           /*■■■■ 59 ■■■■*/
         b  =  .p4( b,   c,   d,   a,   13,   21,   1309151649)           /*■■■■ 60 ■■■■*/
         a  =  .p4( a,   b,   c,   d,    4,    6,   4149444226)           /*■■■■ 61 ■■■■*/
         d  =  .p4( d,   a,   b,   c,   11,   10,   3174756917)           /*■■■■ 62 ■■■■*/
         c  =  .p4( c,   d,   a,   b,    2,   15,    718787259)           /*■■■■ 63 ■■■■*/
         b  =  .p4( b,   c,   d,   a,    9,   21,   3951481745)           /*■■■■ 64 ■■■■*/
         a  =  .a(a_, a);         b=.a(b_, b);          c=.a(c_, c);        d=.a(d_, d)
         end   /*j*/
     return .rx(a).rx(b).rx(c).rx(d)             /*same as:  .rx(a) || .rx(b) ||  ···   */
/*──────────────────────────────────────────────────────────────────────────────────────*/
.a:  return  right( d2c( c2d( arg(1) )   +   c2d( arg(2) ) ),  4, '0'x)
.h:  return  bitxor( bitxor( arg(1), arg(2) ), arg(3) )
.i:  return  bitxor( arg(2), bitor(arg(1),  bitxor(arg(3),        'ffffffff'x) ) )
.f:  return  bitor( bitand(arg(1), arg(2)), bitand(bitxor(arg(1), 'ffffffff'x), arg(3) ) )
.g:  return  bitor( bitand(arg(1), arg(3)), bitand(arg(2), bitxor(arg(3), 'ffffffff'x) ) )
.rx: return  c2x( reverse( arg(1) ) )
.Lr: procedure;  parse arg _,#;    if #==0  then return _             /*left bit rotate.*/
                 ?=x2b(c2x(_));    return x2c( b2x( right(? || left(?, #), length(?) ) ) )
.p1: procedure expose !.;   parse arg w,x,y,z,n,m,_;             n=n + 1
               return .a(.Lr(right(d2c(_+c2d(w) + c2d(.f(x,y,z)) + c2d(!.n)),4,'0'x),m),x)
.p2: procedure expose !.;   parse arg w,x,y,z,n,m,_;             n=n + 1
               return .a(.Lr(right(d2c(_+c2d(w) + c2d(.g(x,y,z)) + c2d(!.n)),4,'0'x),m),x)
.p3: procedure expose !.;   parse arg w,x,y,z,n,m,_;             n=n + 1
               return .a(.Lr(right(d2c(_+c2d(w) + c2d(.h(x,y,z)) + c2d(!.n)),4,'0'x),m),x)
.p4: procedure expose !.;   parse arg w,x,y,z,n,m,_;             n=n + 1
               return .a(.Lr(right(d2c(c2d(w) + c2d(.i(x,y,z)) + c2d(!.n)+_),4,'0'x),m),x)

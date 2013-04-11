/*REXX program to test the  MD5  procedure as per the test suite in the */
/* IETF RFC (1321) ─── The MD5 Message─Digest Algorithm.    April 1992. */

/*─────────────────────────────────────Md5 test suite (from above doc). */
msg.1=''
msg.2='a'
msg.3='abc'
msg.4='message digest'
msg.5='abcdefghijklmnopqrstuvwxyz'
msg.6='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
msg.7='12345678901234567890123456789012345678901234567890123456789012345678901234567890
msg.0=7
               do m=1 for msg.0
               say ' in =' msg.m
               say 'out =' MD5(msg.m)
               say
               end   /*m*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────MD5 subroutine──────────────────────*/
MD5: procedure; parse arg !;  numeric digits 20  /*insure enough digits.*/
parse value '67452301'x 'efcdab89'x '98badcfe'x '10325476'x  with  a b c d
#=length(!)
L=#*8 // 512
               select
               when L<448 then plus=448-L
               when L>448 then plus=960-L
               when L=448 then plus=512
               end   /*select*/

$=!||'80'x||copies('0'x,plus%8-1)reverse(right(d2c(8*#),4,'0'x))||'00000000'x

  do j=0  to length($)%64-1            /*process message (lots of steps)*/
  a_=a;   b_=b;   c_=c;   d_=d
  chunk=j*64
                do k=1 for 16          /*process the message in chunks. */
                !.k=reverse(substr($,chunk+1+4*(k-1),4))
                end   /*k*/

  a=.part1(a,b,c,d, 0, 7,3614090360) /* 1*/
  d=.part1(d,a,b,c, 1,12,3905402710) /* 2*/
  c=.part1(c,d,a,b, 2,17, 606105819) /* 3*/
  b=.part1(b,c,d,a, 3,22,3250441966) /* 4*/
  a=.part1(a,b,c,d, 4, 7,4118548399) /* 5*/
  d=.part1(d,a,b,c, 5,12,1200080426) /* 6*/
  c=.part1(c,d,a,b, 6,17,2821735955) /* 7*/
  b=.part1(b,c,d,a, 7,22,4249261313) /* 8*/
  a=.part1(a,b,c,d, 8, 7,1770035416) /* 9*/
  d=.part1(d,a,b,c, 9,12,2336552879) /*10*/
  c=.part1(c,d,a,b,10,17,4294925233) /*11*/
  b=.part1(b,c,d,a,11,22,2304563134) /*12*/
  a=.part1(a,b,c,d,12, 7,1804603682) /*13*/
  d=.part1(d,a,b,c,13,12,4254626195) /*14*/
  c=.part1(c,d,a,b,14,17,2792965006) /*15*/
  b=.part1(b,c,d,a,15,22,1236535329) /*16*/
  a=.part2(a,b,c,d, 1, 5,4129170786) /*17*/
  d=.part2(d,a,b,c, 6, 9,3225465664) /*18*/
  c=.part2(c,d,a,b,11,14, 643717713) /*19*/
  b=.part2(b,c,d,a, 0,20,3921069994) /*20*/
  a=.part2(a,b,c,d, 5, 5,3593408605) /*21*/
  d=.part2(d,a,b,c,10, 9,  38016083) /*22*/
  c=.part2(c,d,a,b,15,14,3634488961) /*23*/
  b=.part2(b,c,d,a, 4,20,3889429448) /*24*/
  a=.part2(a,b,c,d, 9, 5, 568446438) /*25*/
  d=.part2(d,a,b,c,14, 9,3275163606) /*26*/
  c=.part2(c,d,a,b, 3,14,4107603335) /*27*/
  b=.part2(b,c,d,a, 8,20,1163531501) /*28*/
  a=.part2(a,b,c,d,13, 5,2850285829) /*29*/
  d=.part2(d,a,b,c, 2, 9,4243563512) /*30*/
  c=.part2(c,d,a,b, 7,14,1735328473) /*31*/
  b=.part2(b,c,d,a,12,20,2368359562) /*32*/
  a=.part3(a,b,c,d, 5, 4,4294588738) /*33*/
  d=.part3(d,a,b,c, 8,11,2272392833) /*34*/
  c=.part3(c,d,a,b,11,16,1839030562) /*35*/
  b=.part3(b,c,d,a,14,23,4259657740) /*36*/
  a=.part3(a,b,c,d, 1, 4,2763975236) /*37*/
  d=.part3(d,a,b,c, 4,11,1272893353) /*38*/
  c=.part3(c,d,a,b, 7,16,4139469664) /*39*/
  b=.part3(b,c,d,a,10,23,3200236656) /*40*/
  a=.part3(a,b,c,d,13, 4, 681279174) /*41*/
  d=.part3(d,a,b,c, 0,11,3936430074) /*42*/
  c=.part3(c,d,a,b, 3,16,3572445317) /*43*/
  b=.part3(b,c,d,a, 6,23,  76029189) /*44*/
  a=.part3(a,b,c,d, 9, 4,3654602809) /*45*/
  d=.part3(d,a,b,c,12,11,3873151461) /*46*/
  c=.part3(c,d,a,b,15,16, 530742520) /*47*/
  b=.part3(b,c,d,a, 2,23,3299628645) /*48*/
  a=.part4(a,b,c,d, 0, 6,4096336452) /*49*/
  d=.part4(d,a,b,c, 7,10,1126891415) /*50*/
  c=.part4(c,d,a,b,14,15,2878612391) /*51*/
  b=.part4(b,c,d,a, 5,21,4237533241) /*52*/
  a=.part4(a,b,c,d,12, 6,1700485571) /*53*/
  d=.part4(d,a,b,c, 3,10,2399980690) /*54*/
  c=.part4(c,d,a,b,10,15,4293915773) /*55*/
  b=.part4(b,c,d,a, 1,21,2240044497) /*56*/
  a=.part4(a,b,c,d, 8, 6,1873313359) /*57*/
  d=.part4(d,a,b,c,15,10,4264355552) /*58*/
  c=.part4(c,d,a,b, 6,15,2734768916) /*59*/
  b=.part4(b,c,d,a,13,21,1309151649) /*60*/
  a=.part4(a,b,c,d, 4, 6,4149444226) /*61*/
  d=.part4(d,a,b,c,11,10,3174756917) /*62*/
  c=.part4(c,d,a,b, 2,15, 718787259) /*63*/
  b=.part4(b,c,d,a, 9,21,3951481745) /*64*/
  a=.a(a_,a);     b=.a(b_,b);     c=.a(c_,c);     d=.a(d_,d)
  end   /*j*/

return c2x(reverse(a))c2x(reverse(b))c2x(reverse(c))c2x(reverse(d))
/*─────────────────────────────────────subroutines──────────────────────*/
.part1: procedure expose !.;   parse arg w,x,y,z,n,m,_;   n=n+1
    return .a(.lR(right(d2c(_+c2d(w)+c2d(.f(x,y,z))+c2d(!.n)),4,'0'x),m),x)
.part2: procedure expose !.;   parse arg w,x,y,z,n,m,_;   n=n+1
    return .a(.lR(right(d2c(_+c2d(w)+c2d(.g(x,y,z))+c2d(!.n)),4,'0'x),m),x)
.part3: procedure expose !.;   parse arg w,x,y,z,n,m,_;   n=n+1
    return .a(.lR(right(d2c(_+c2d(w)+c2d(.h(x,y,z))+c2d(!.n)),4,'0'x),m),x)
.part4: procedure expose !.;   parse arg w,x,y,z,n,m;     n=n+1
    return .a(.lR(right(d2c(c2d(w)+c2d(.i(x,y,z))+c2d(!.n)+arg(7)),4,'0'x),m),x)
.h:  procedure;  parse arg x,y,z;   return bitxor(bitxor(x,y),z)
.i:  return bitxor(arg(2),bitor(arg(1),bitxor(arg(3),'ffffffff'x)))
.a:  return right(d2c(c2d(arg(1))+c2d(arg(2))),4,'0'x)
.f:  procedure;  parse arg x,y,z
     return bitor(bitand(x,y),bitand(bitxor(x,'ffffffff'x),z))
.g:  procedure;  parse arg x,y,z
     return bitor(bitand(x,z),bitand(y,bitxor(z,'ffffffff'x)))
.lR: procedure;  parse arg _,#;  if #==0 then return _    /*left rotate.*/
     ?=x2b(c2x(_)); return x2c(b2x(right(?||left(?,#),length(?))))

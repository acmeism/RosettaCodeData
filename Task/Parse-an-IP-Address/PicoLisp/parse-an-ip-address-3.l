*process or(!) source xref attributes macro options;
 /*********************************************************************
 * Program to parse an IP address into -->   IPv4 or IPv6 format
 * 28.05.2013 Walter Pachl translated from REXX version 3
 *                         x2d was the hard part :-)
 *********************************************************************/
 ip: proc options(main);
 Dcl ipa   char(50) Var;
 Dcl ipi   char(50) Var;
 Dcl ipax  char(50) Var Init('');
 Dcl ipad  char(50) Var Init('');
 Dcl space char(4);
 Dcl port  char(5) Var;
 dcl head Char(132) Var;
 head='       input IP address                 hex IP address   '!!
      '                 decimal IP address            space  port';
 Put Edit(head)(Skip,a);
 Put Edit(copies('_',30),
          copies('_',32),
          copies('_',39),
          copies('_', 5),
          copies('_', 5))
         (Skip,6(a,x(1)));

 call expand('127.0.0.1');
 call expand('127.0.0.1:80');
 call expand('2605:2700:0:3::4713:93e3');
 call expand('[2605:2700:0:3::4713:93e3]:80');
 call expand('::1');
 call expand('[::1]:80');

 expand: procedure(s);
 Dcl s Char(50) Var;
 ipi=s;
 ipa=s;
 If index(ipa,'.')>0 Then
   Call expand_ipv4;
 Else
   Call expand_ipv6;
 ipad=x2d(ipax);
 Put Edit(left(ipi,30),right(ipax,32),right(ipad,39),
          right(space,5),right(port,5))
         (Skip,6(a,x(1)));
 End;

 expand_ipv4: Proc;
 Dcl a(4) Char(3) Var;
 Dcl (pp,j) Bin Fixed(31);
 space='IPv4';
 pp=index(ipa,':');
 If pp>0 Then Do;
   port=substr(ipa,pp+1);
   ipa=left(ipa,pp-1);
   End;
 Else
   Port='';
 Call parse((ipa),'.',a);
 ipax='';
 do j=1 To 4;
   ipax=ipax!!a(j);
   end;
 End;

 expand_ipv6: Proc;
 Dcl a(8) Char(4) Var;
 Dcl (s,o1,o2) Char(50) Var Init('');
 Dcl (i,ii,pp,j,n) Bin Fixed(31) Init(0);
 space='IPv6';
 pp=index(ipa,']:');
 If pp>0 Then Do;
   port=substr(ipa,pp+2);
   ipa=substr(ipa,2,pp-2);
   End;
 Else
   Port='';
 s=ipa;
 j=0;
 Do i=1 To 8 While(s>'');
   pp=index(s,':');
   dcl temp Char(6) Var;
   If pp>1 Then
     temp=left(s,pp-1);
   Else
     temp=s;
   temp=right(temp,4,'0');
   Select(pp);
     When(0) Do;
       a(i)=temp;
       s='';
       End;
     When(1) Do;
       a(i)='----';
       ii=i;
       s=substr(s,pp+1);
       If left(s,1)=':' Then
         s=substr(s,2);
       End;
     Otherwise Do;
       a(i)=temp;
       s=substr(s,pp+1);
       End;
     End;
   End;
 n=i-1;
 o1='';
 o2='';
 Do i=1 To n;
   If i=ii Then Do;
     o1=o1!!'----';
     Do j=1 To 9-n;
       o2=o2!!'0000';
       End;
     End;
   Else Do;
     o1=o1!!right(a(i),4,'0');
     o2=o2!!right(a(i),4,'0');
     End;
   End;
  ipax=o2;
 End;

 parse: Proc(s,c,a);
 Dcl s Char(50) Var;
 Dcl c Char( 1);
 Dcl a(*) Char(*) Var;
 Dcl (i,p) Bin Fixed(31);
 a='';
 Do i=1 By 1 While(length(s)>0);
   p=index(s,c);
   If p>0 Then Do;
     a(i)=left(s,p-1);
     s=substr(s,p+1);
     End;
   Else Do;
     a(i)=s;
     s='';
     End;
   End;
  End;

 /*
 underscore: Proc(s) Returns(char(132) Var);
 Dcl s Char(*);
 Dcl r Char(length(s)) Var Init('');
 Dcl i Bin Fixed(31);
 Dcl us Bit(1) Init('0'b);
 Do i=1 To length(s)-1;
   If substr(s,i,1)>' ' Then Do;
     r=r!!'_';
     us='1'b;
     End;
   Else Do;
     If substr(s,i+1,1)>' ' & us Then
       r=r!!'_';
     Else Do;
       r=r!!' ';
       us='0'b;
       End;
     End;
   End;
 If substr(s,length(s),1)>' ' Then
   r=r!!'_';
 Return(r);
 End;

 center: Proc(s,l) Returns(char(50) Var);
 Dcl s char(50) Var;
 Dcl (l,b) Bin Fixed(31);
 b=(l-length(s))/2;
 Return(left(copies(' ',b)!!s,l));
 End;
 */
 copies: Proc(c,n) Returns(char(50) Var);
 Dcl c char(50) Var;
 Dcl n Bin Fixed(31);
 Return(repeat(c,n-1));
 End;


 c2d: Procedure(s) Returns(Char(50) Var);
 Dcl s Char(*) Var;
 Dcl d Pic'99';
 Dcl (v,part,result,old) Char(100) Var;
 Dcl i Bin Fixed(31);
 result='0';
 v='1';

 Do i=length(s) To 1 By -1;
   d=c2d(substr(s,i,1));
   part=longmult((v),(d));
   result=longadd((result),(part));
   v=longmult((v),'16');
   End;
 Do While(left(result,1)='0');
   result=substr(result,2);
   End;
 Return(result);
 /*
 dbg: Proc(txt);
 Dcl txt Char(*);
 Put Skip list(txt);
 End;
 */
 x2d: Procedure(c) Returns(Char(2));
 Dcl c Char(1);
 Dcl res Char(2);
 Select(c);
   When('a','A') res='10';
   When('b','B') res='11';
   When('c','C') res='12';
   When('d','D') res='13';
   When('e','E') res='14';
   When('f','F') res='15';
   Otherwise res='0'!!c;
   End;
 Return(res);
 End;

 longmult: Procedure(as,bs) Returns(Char(1000) Var);
 /* REXX **************************************************************
 * Multiply(as,bs) -> as*bs
 *********************************************************************/
 Dcl (as,bs) Char(*);
 Dcl (a(1000),b(1000),r(1000)) Pic'9';
 Dcl (p,s) Pic'99';
 Dcl (al,bl) Bin Fixed(31);
 Dcl (i,ai,bi,ri,rim) Bin Fixed(31);
 Dcl res Char(1000) Var Init((1000)'0');
 al=length(as); Do ai=al To 1 By -1; a(ai)=substr(as,al-ai+1,1); End;
 bl=length(bs); Do bi=bl To 1 By -1; b(bi)=substr(bs,bl-bi+1,1); End;
 r=0;
 rim=0;
 Do bi=1 To bl;
   Do ai=1 To al;
     ri=ai+bi-1;
     p=a(ai)*b(bi);
     Do i=ri by 1 Until(p=0);
       s=r(i)+p;
       r(i)=mod(s,10);
       p=s/10;
       End;
     rim=max(rim,i);
     End;
   End;
 res='';
 Do i=1 To rim;
   res=r(i)!!res;
   End;
 Return(res);
 End;

 longadd: proc(as,bs) Returns(Char(100) Var);
 Dcl (as,bs) Char(*) Var;
 Dcl cs Char(100) Var Init('');
 Dcl (al,bl,cl,i) Bin Fixed(31);
 Dcl a(100) Pic'9' Init((100)0);
 Dcl b(100) Pic'9' Init((100)0);
 Dcl c(100) Pic'9' Init((100)0);
 Dcl temp Pic'99';
 al=length(as);
 bl=length(bs);
 Do i=1 To al; a(i)=substr(as,al-i+1,1); End;
 Do i=1 To bl; b(i)=substr(bs,bl-i+1,1); End;
 cl=max(al,bl)+1;
 Do i=1 To cl;
   temp=a(i)+b(i)+c(i);
   c(i)=mod(temp,10);
   c(i+1)=c(i+1)+temp/10;
   End;
 Do i=1 To cl;
   cs=c(i)!!cs;
   End;
 Return(cs);
 End;
 End;

 end;

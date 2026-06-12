   N=: {{(}.":1e4+y),'+-'{~3<y}}
   R=: {{5{.y#x}}
   ('A'&R,'B'&R,N,'D'&R)&>1+i.5
A    B    0001+D
AA   BB   0002+DD
AAA  BBB  0003+DDD
AAAA BBBB 0004-DDDD
AAAAABBBBB0005-DDDDD
   (('A'&R,'B'&R,N,'D'&R)&>1+i.5) fwrite 'example'
100

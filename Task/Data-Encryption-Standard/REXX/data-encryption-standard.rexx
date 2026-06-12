/* REXX for the sake of some platforms such as good old iron */
Parse Upper Arg action
Select
  When action='?' Then Do
    Say "REXX des shows     how '8787878787878787'X is encoded to"
    Say "                       '000000000000000'X"
    Say "REXX des DEC shows how '000000000000000'X is decoded to"
    Say "                       '8787878787878787'X"
    Exit
    End
  When action='' | action='ENC' Then
    encode=1
  When action='' | action='DEC' Then
    encode=0
  Otherwise Do
    Say 'Invalid argument' action '(must be ENC or DEC or omitted)'
    Exit
    End
  End
o='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.-'
Call init
Call debug 'tr_pc_1='tr_pc_1
Call debug 'tr_ip  ='tr_ip
Call debug 'tr_p   ='tr_p
Call debug 'tr_ipa ='tr_ipa

kx='0e329232ea6d0d73'
If encode Then
  mx='8787878787878787'
Else
  mx='0000000000000000'
k=x2b(kx)
m=x2b(mx)
Say 'Message:' mx
Say 'Key    :' kx
ka=translate(tr_pc_1,k,o)
Call debug 'ka='ka
Parse Var ka c.0 +28 d.0
shifts='1 1 2 2 2 2 2 2 1 2 2 2 2 2 2 1'
Do i=1 To 16
  ip=i-1
  c.i=shift(c.ip,word(shifts,i))
  d.i=shift(d.ip,word(shifts,i))
  End
Do i=1 To 16
  cd.i=c.i||d.i
  k.i=translate(tr_pc_2,cd.i,o)
  Call debug 'k.'i'='k.i
  End

If encode=0 Then Do /*revert the subkeys */
  Do i=1 To 16
    j=17-i
    kd.i=k.j
    End
  Do i=1 To 16
    k.i=kd.i
    End
  End

IP=translate(tr_ip,m,o)
Call debug 'ip='ip

Parse Var ip l.0 +32 r.0

Call debug 'E(R.0)='E(R.0)
Call debug 'k.1   ='k.1
t=xor(k.1,E(R.0))
Call debug 't     ='t
Call debug length(t)
zz=''
Do i=1 To 8
  Parse Var t b +6 t
  zz=zz||s(i,b)
  End
Call debug 'zz='zz
f=translate(tr_p,zz,o)
Call debug 'f='f
r.1=xor(l.0,f)
Call debug 'r.1='r.1
l.1=r.0
Do j=2 To 16
  ja=j-1
  l.j=r.ja
  z=xor(k.j,e(r.ja))
  zz=''
  Do i=1 To 8
    Parse Var z b +6 z
    zz=zz||s(i,b)
    End
  Call debug j zz
  f=translate(tr_p,zz,o)
  Call debug j f
  r.j=xor(l.ja,f)
  End
Call debug 'l.16='l.16
Call debug 'r.16='r.16

zzz=r.16||l.16
c=translate(tr_ipa,zzz,o)
Call debug c
Say 'Result :' b2x(c)
Exit

f: Procedure Expose s. o tr_p
  Parse Arg r,k
  z=xor(k,e(r))
  zz=translate(tr_p,z,o)
  Return zz

init:
PC_1='57 49 41 33 25 17  9',
     ' 1 58 50 42 34 26 18',
     '10  2 59 51 43 35 27',
     '19 11  3 60 52 44 36',
     '63 55 47 39 31 23 15',
     ' 7 62 54 46 38 30 22',
     '14  6 61 53 45 37 29',
     '21 13  5 28 20 12  4'

tr_pc_1=''
Do i=1 To words(pc_1)
  tr_pc_1=tr_pc_1||substr(o,word(pc_1,i),1)
  End
tr_pc_1=tr_pc_1

kb=translate(tr_pc_1,k,o)
kc=strip(kb,,'*')

PC_2='14  17  11  24   1   5',
     ' 3  28  15   6  21  10',
     '23  19  12   4  26   8',
     '16   7  27  20  13   2',
     '41  52  31  37  47  55',
     '30  40  51  45  33  48',
     '44  49  39  56  34  53',
     '46  42  50  36  29  32'
tr_pc_2=''
Do i=1 To words(pc_2)
  tr_pc_2=tr_pc_2||substr(o,word(pc_2,i),1)
  End

Do i=1 To 16
  cd.i=c.i||d.i
  k.i=translate(ok,cd.i,o)
  Call debug 'k.'i'='k.i
  End

IP='58 50 42 34 26 18 10  2',
   '60 52 44 36 28 20 12  4',
   '62 54 46 38 30 22 14  6',
   '64 56 48 40 32 24 16  8',
   '57 49 41 33 25 17  9  1',
   '59 51 43 35 27 19 11  3',
   '61 53 45 37 29 21 13  5',
   '63 55 47 39 31 23 15  7'
tr_ip=''
Do i=1 To words(IP)
  tr_ip=tr_ip||substr(o,word(ip,i),1)
  End


P='16  7 20 21',
  '29 12 28 17',
  ' 1 15 23 26',
  ' 5 18 31 10',
  ' 2  8 24 14',
  '32 27  3  9',
  '19 13 30  6',
  '22 11  4 25'
tr_p=''
Do i=1 To words(p)
  tr_p=tr_p||substr(o,word(p,i),1)
  End

SM.1='14  4  13  1   2 15  11  8   3 10   6 12   5  9   0  7',
     ' 0 15   7  4  14  2  13  1  10  6  12 11   9  5   3  8',
     ' 4  1  14  8  13  6   2 11  15 12   9  7   3 10   5  0',
     '15 12   8  2   4  9   1  7   5 11   3 14  10  0   6 13'
SM.2='15  1   8 14   6 11   3  4   9  7   2 13  12  0   5 10',
     ' 3 13   4  7  15  2   8 14  12  0   1 10   6  9  11  5',
     ' 0 14   7 11  10  4  13  1   5  8  12  6   9  3   2 15',
     '13  8  10  1   3 15   4  2  11  6   7 12   0  5  14  9'
SM.3='10  0   9 14   6  3  15  5   1 13  12  7  11  4   2  8',
     '13  7   0  9   3  4   6 10   2  8   5 14  12 11  15  1',
     '13  6   4  9   8 15   3  0  11  1   2 12   5 10  14  7',
     ' 1 10  13  0   6  9   8  7   4 15  14  3  11  5   2 12'
SM.4=' 7 13  14  3   0  6   9 10   1  2   8  5  11 12   4 15',
     '13  8  11  5   6 15   0  3   4  7   2 12   1 10  14  9',
     '10  6   9  0  12 11   7 13  15  1   3 14   5  2   8  4',
     ' 3 15   0  6  10  1  13  8   9  4   5 11  12  7   2 14'
SM.5=' 2 12   4  1   7 10  11  6   8  5   3 15  13  0  14  9',
     '14 11   2 12   4  7  13  1   5  0  15 10   3  9   8  6',
     ' 4  2   1 11  10 13   7  8  15  9  12  5   6  3   0 14',
     '11  8  12  7   1 14   2 13   6 15   0  9  10  4   5  3'
SM.6='12  1  10 15   9  2   6  8   0 13   3  4  14  7   5 11',
     '10 15   4  2   7 12   9  5   6  1  13 14   0 11   3  8',
     ' 9 14  15  5   2  8  12  3   7  0   4 10   1 13  11  6',
     ' 4  3   2 12   9  5  15 10  11 14   1  7   6  0   8 13'
SM.7=' 4 11   2 14  15  0   8 13   3 12   9  7   5 10   6  1',
     '13  0  11  7   4  9   1 10  14  3   5 12   2 15   8  6',
     ' 1  4  11 13  12  3   7 14  10 15   6  8   0  5   9  2',
     ' 6 11  13  8   1  4  10  7   9  5   0 15  14  2   3 12'
SM.8='13  2   8  4   6 15  11  1  10  9   3 14   5  0  12  7',
     ' 1 15  13  8  10  3   7  4  12  5   6 11   0 14   9  2',
     ' 7 11   4  1   9 12  14  2   0  6  10 13  15  3   5  8',
     ' 2  1  14  7   4 10   8 13  15 12   9  0   3  5   6 11'
Do i=1 To 8
  Do r=0 To 3
    Do c=0 To 15
      Parse Var sm.i s.i.r.c sm.i
      End
    End
  End

ipa='40  8 48 16 56 24 64 32',
    '39  7 47 15 55 23 63 31',
    '38  6 46 14 54 22 62 30',
    '37  5 45 13 53 21 61 29',
    '36  4 44 12 52 20 60 28',
    '35  3 43 11 51 19 59 27',
    '34  2 42 10 50 18 58 26',
    '33  1 41  9 49 17 57 25'
tr_ipa=''
Do i=1 To words(ipa)
  tr_ipa=tr_ipa||substr(o,word(ipa,i),1)
  End

Return

shift: Procedure
  Parse Arg in,s
  out=substr(in,s+1)left(in,s)
  Return out

E: Procedure
Parse Arg s
esel='32  1  2  3  4  5',
     ' 4  5  6  7  8  9',
     ' 8  9 10 11 12 13',
     '12 13 14 15 16 17',
     '16 17 18 19 20 21',
     '20 21 22 23 24 25',
     '24 25 26 27 28 29',
     '28 29 30 31 32  1'
r=''
Do i=1 To words(esel)
  r=r||substr(s,word(esel,i),1)
  End
Return r

xor: Procedure
Parse Arg u,v
r=''
Do i=1 To length(u)
  cc=substr(u,i,1)substr(v,i,1)
  r=r||(pos(cc,'01 10')>0)
  End
Return r

s: Procedure Expose s.
  Parse Arg i,b
  Parse Var b r1 +1 c +4 r2
  r=r1||r2
  rb=num(r)
  cb=num(c)
  result=s.i.rb.cb
  Return num2bits(result)

num: Procedure
  Parse Arg s
  res=0
  Do i=1 To length(s)
    Parse Var s c +1 s
    res=2*res+c
    End
  Return res

num2bits: Procedure
  Parse Arg n
  nx=d2x(n)
  r=''
  Do i=1 To 4
    dig=n//2
    r=dig||r
    n=n%2
    End
  Return r

debug: /* Say arg(1) */ Return

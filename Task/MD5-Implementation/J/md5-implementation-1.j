NB. convert/misc/md5
NB. RSA Data Security, Inc. MD5 Message-Digest Algorithm
NB. version: 1.0.2
NB.
NB. See RFC 1321 for license details
NB. J implementation -- (C) 2003 Oleg Kobchenko;
NB.
NB. 09/04/2003 Oleg Kobchenko
NB. 03/31/2007 Oleg Kobchenko j601, JAL
NB. 12/17/2015 G.Pruss 64-bit
NB. ~60+ times slower than using the jqt library

require 'convert'
coclass 'pcrypt'

NB. lt= (*. -.)~   gt= *. -.   ge= +. -.   xor= ~:
'`lt gt ge xor'=: (20 b.)`(18 b.)`(27 b.)`(22 b.)
'`and or sh'=: (17 b.)`(23 b.)`(33 b.)

3 : 0 ''
if. IF64 do.
rot=: (16bffffffff and sh or ] sh~ 32 -~ [) NB. (y << x) | (y >>> (32 - x))
add=: ((16bffffffff&and)@+)"0
else.
rot=: (32 b.)
add=: (+&(_16&sh) (16&sh@(+ _16&sh) or and&65535@]) +&(and&65535))"0
end.
EMPTY
)

hexlist=: tolower@:,@:hfd@:,@:(|."1)@(256 256 256 256&#:)

cmn=: 4 : 0
'x s t'=. x [ 'q a b'=. y
b add s rot (a add q) add (x add t)
)

ff=: cmn (((1&{ and 2&{) or 1&{ lt 3&{) , 2&{.)
gg=: cmn (((1&{ and 3&{) or 2&{ gt 3&{) , 2&{.)
hh=: cmn (((1&{ xor 2&{)xor 3&{       ) , 2&{.)
ii=: cmn (( 2&{ xor 1&{  ge 3&{       ) , 2&{.)
op=: ff`gg`hh`ii

I=: ".;._2(0 : 0)
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
1 6 11 0 5 10 15 4 9 14 3 8 13 2 7 12
5 8 11 14 1 4 7 10 13 0 3 6 9 12 15 2
0 7 14 5 12 3 10 1 8 15 6 13 4 11 2 9
)
S=: 4 4$7 12 17 22 5 9 14 20 4 11 16 23 6 10 15 21

T=: |:".;._2(0 : 0)
 _680876936  _165796510     _378558  _198630844
 _389564586 _1069501632 _2022574463  1126891415
  606105819   643717713  1839030562 _1416354905
_1044525330  _373897302   _35309556   _57434055
 _176418897  _701558691 _1530992060  1700485571
 1200080426    38016083  1272893353 _1894986606
_1473231341  _660478335  _155497632    _1051523
  _45705983  _405537848 _1094730640 _2054922799
 1770035416   568446438   681279174  1873313359
_1958414417 _1019803690  _358537222   _30611744
     _42063  _187363961  _722521979 _1560198380
_1990404162  1163531501    76029189  1309151649
 1804603682 _1444681467  _640364487  _145523070
  _40341101   _51403784  _421815835 _1120210379
_1502002290  1735328473   530742520   718787259
 1236535329 _1926607734  _995338651  _343485551
)

norm=: 3 : 0
n=. 16 * 1 + _6 sh 8 + #y
b=. n#0  [  y=. a.i.y
for_i. i. #y do.
  b=. ((j { b) or (8*4|i) sh i{y) (j=. _2 sh i) } b
end.
b=. ((j { b) or (8*4|i) sh 128) (j=._2 sh i=.#y) } b
_16]\ (8 * #y) (n-2) } b
)

NB.*md5 v MD5 Message-Digest Algorithm
NB.  diagest=. md5 message
md5=: 3 : 0
X=. norm y
q=. r=. 1732584193 _271733879 _1732584194 271733878
for_x. X do.
  for_j. i.4 do.
    l=. ((j{I){x) ,. (16$j{S) ,. j{T
    for_i. i.16 do.
      r=. _1|.((i{l) (op@.j) r),}.r
    end.
  end.
  q=. r=. r add q
end.
hexlist r
)

md5_z_=: md5_pcrypt_

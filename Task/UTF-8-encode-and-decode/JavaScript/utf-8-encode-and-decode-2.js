const
  str=
    'AöЖ€𝄞'
 ,cps=
    Uint32Array.from(str,s=>s.codePointAt(0))
 ,cus=
    [ [ 0x41]
     ,[ 0xc3,0xb6]
     ,[ 0xd0,0x96]
     ,[ 0xe2,0x82,0xac]
     ,[ 0xf0,0x9d,0x84,0x9e]]
   .map(a=>Uint8Array.from(a))
 ,zip3=
    ([a,...as],[b,...bs],[c,...cs])=>
      0<as.length+bs.length+cs.length
     ?[ [ a,b,c],...zip3(as,bs,cs)]
     :[ [ a,b,c]]
 ,inputs=zip3(str,cps,cus);

; GLOBAL CONSTANTS r[64], k[64]
r =  12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22
, 5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20
, 4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23
, 6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21
StringSplit r, r, `,
r0 := 7
Loop 64
   i := A_Index-1, k%i% := floor(abs(sin(A_Index)) * 2**32)

; TEST CASES
MsgBox % MD5(x:="", 0) ; d41d8cd98f00b204e9800998ecf8427e
MsgBox % MD5(x:="a", StrLen(x)) ; 0cc175b9c0f1b6a831c399e269772661
MsgBox % MD5(x:="abc", StrLen(x)) ; 900150983cd24fb0d6963f7d28e17f72
MsgBox % MD5(x:="message digest", StrLen(x)) ; f96b697d7cb7938d525a2f31aaf161d0
MsgBox % MD5(x:="abcdefghijklmnopqrstuvwxyz", StrLen(x))
; c3fcd3d76192e4007dfb496cca67e13b
MsgBox % MD5(x:="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789", StrLen(x))
; d174ab98d277d9f5a5611c2c9f419d9f
MsgBox % MD5(x:="12345678901234567890123456789012345678901234567890123456789012345678901234567890", StrLen(x))
; 57edf4a22be3c955ac49da2e2107b67a
MsgBox % MD5(x:="The quick brown fox jumps over the lazy dog", StrLen(x))
; 9e107d9d372bb6826bd81d3542a419d6
MsgBox % MD5(x:="The quick brown fox jumps over the lazy cog", StrLen(x))
; 1055d3e698d289f2af8663725127bd4b

MD5(ByRef Buf, L) { ; Binary buffer, Length in bytes
   Static P, Q, N, i, a,b,c,d, t, h0,h1,h2,h3, y = 0xFFFFFFFF

   h0 := 0x67452301, h1 := 0xEFCDAB89, h2 := 0x98BADCFE, h3 := 0x10325476

   N := ceil((L+9)/64)*64 ; padded length (100..separator, 8B length)
   VarSetCapacity(Q,N,0)  ; room for padded data
   P := &Q ; pointer
   DllCall("RtlMoveMemory", UInt,P, UInt,&Buf, UInt,L) ; copy data
   DllCall("RtlFillMemory", UInt,P+L, UInt,1, UInt,0x80) ; pad separator
   DllCall("ntdll.dll\RtlFillMemoryUlong",UInt,P+N-8,UInt,4,UInt,8*L) ; at end: length in bits < 512 MB

   Loop % N//64 {
      Loop 16
         i := A_Index-1, w%i% := *P | *(P+1)<<8 | *(P+2)<<16 | *(P+3)<<24, P += 4

      a := h0, b := h1, c := h2, d := h3

      Loop 64 {
         i := A_Index-1
         If i < 16
             f := (b & c) | (~b & d), g := i
         Else If i < 32
             f := (d & b) | (~d & c), g := 5*i+1 & 15
         Else If i < 48
             f := b ^ c ^ d,          g := 3*i+5 & 15
         Else
             f := c ^ (b | ~d),       g :=  7*i  & 15

         t := d, d := c, c := b
         b += rotate(a + f + k%i% + w%g%, r%i%) ; reduced to 32 bits later
         a := t
      }

      h0 := h0+a & y, h1 := h1+b & y, h2 := h2+c & y, h3 := h3+d & y
   }
   Return hex(h0) . hex(h1) . hex(h2) . hex(h3)
}

rotate(a,b) { ; 32-bit rotate a to left by b bits, bit32..63 garbage
   Return a << b | (a & 0xFFFFFFFF) >> (32-b)
}

hex(x) {      ; 32-bit little endian hex digits
   SetFormat Integer, HEX
   x += 0x100000000, x := SubStr(x,-1) . SubStr(x,8,2) . SubStr(x,6,2) . SubStr(x,4,2)
   SetFormat Integer, DECIMAL
   Return x
}

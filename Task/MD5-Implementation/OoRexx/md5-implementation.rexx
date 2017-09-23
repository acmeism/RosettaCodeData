#!/usr/bin/rexx

/* Expected results:
   0xd41d8cd98f00b204e9800998ecf8427e <== ""
   0x0cc175b9c0f1b6a831c399e269772661 <== "a"
   0x900150983cd24fb0d6963f7d28e17f72 <== "abc"
   0xf96b697d7cb7938d525a2f31aaf161d0 <== "message digest"
   0xc3fcd3d76192e4007dfb496cca67e13b <== "abcdefghijklmnopqrstuvwxyz"
   0xd174ab98d277d9f5a5611c2c9f419d9f <== "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
   0x57edf4a22be3c955ac49da2e2107b67a <== "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
*/

md5 = .md5~new; md5~update(""); say md5~digest
md5 = .md5~new; md5~update("a"); say md5~digest
md5 = .md5~new; md5~update("abc"); say md5~digest
md5 = .md5~new; md5~update("message digest"); say md5~digest
md5 = .md5~new("abcdefghijklmnopqrstuvwxyz"); say md5~digest
md5 = .md5~new("ABCDEFGHIJKLMNOPQRSTUVWXYZ"); md5~update("abcdefghijklmnopqrstuvwxyz0123456789"); say md5~digest
md5 = .md5~new; md5~update("12345678901234567890123456789012345678901234567890123456789012345678901234567890"); say md5~digest

-- requires OORexx 4.2.0 or later
-- standard numeric digits of 9 is not enough in this case
::options digits 20

-- Implementation mainly based on pseudocode in https://en.wikipedia.org/wiki/MD5
::class md5 public

::method init
expose a0 b0 c0 d0 count buffer index K. s  -- instance variables
use strict arg chunk=""
-- Initialize message digest
a0 = .int32~new('67452301'x,"C")   -- A
b0 = .int32~new('efcdab89'x,"C")   -- B
c0 = .int32~new('98badcfe'x,"C")   -- C
d0 = .int32~new('10325476'x,"C")   -- D
-- The 512 bit chunk buffer
buffer = .mutablebuffer~new('00'x~copies(64),64)
-- The position in the buffer to insert new input
index = 1
-- message bytecount
count = 0
-- initialize leftrotate amounts
nrs = .array~of(7,12,17,22)
s = nrs~union(nrs)~union(nrs)~union(nrs)
nrs = .array~of(5,9,14,20)
s = s~union(nrs)~union(nrs)~union(nrs)~union(nrs)
nrs = .array~of(4,11,16,23)
s = s~union(nrs)~union(nrs)~union(nrs)~union(nrs)
nrs = .array~of(6,10,15,21)
s = s~union(nrs)~union(nrs)~union(nrs)~union(nrs)
-- initialize sinus derived constants.
-- sin function from RXMath Library shipped with OORexx
-- see ::routine directive at the end of the code
do i=0 to 63
  K.i = .int32~new(((2**32)*(sin(i+1,16,R)~abs))~floor)
end
-- process initial string if any
self~update(chunk)
exit

::method update
  expose a0 b0 c0 d0 count buffer index K. s  -- instance variables
  use strict arg chunk
  count += chunk~length
  if chunk~length<65-index then do
    buffer~overlay(chunk,index)
    index += chunk~length
  end
  else do
    split = 65-index+1
    parse var chunk part =(split) chunk
    buffer~overlay(part,index)
    index = 65
  end
  -- Only proces completely filled buffer
  do while index=65
    A = a0
    B = b0
    C = c0
    D = d0
    do i=0 to 63
      select
        when i<16 then do
          F = D~xor(B~and(C~xor(D)))
          g = i
        end
        when i<32 then do
          F = C~xor(D~and(B~xor(C)))
          g = (5*i+1)//16
        end
        when i<48 then do
          F = B~xor(C)~xor(D)
          g = (3*i+5)//16
        end
        otherwise do
          F = C~xor(B~or(D~xor(.int32~new('ffffffff'x,"C"))))
          g = (7*i)//16
        end
      end
      M = .int32~new(buffer~substr(g*4+1,4)~reverse,"C")  -- 32bit word in little-endian
      dTemp = D
      D = C
      C = B
      B = (B + (A+F+K.i+M)~bitrotate(s[i+1]))
      A = dTemp
    end
    a0 = a0+A
    b0 = b0+B
    c0 = c0+C
    d0 = d0+D
    parse var chunk part 65 chunk
    index = part~length+1
    buffer~overlay(part,1,part~length)
  end
exit

::method digest
  expose a0 b0 c0 d0 count buffer index K s -- instance variables
  padlen = 64
  if index<57 then padlen = 57-index
  if index>57 then padlen = 121-index
  padding = '00'x~copies(padlen)~bitor('80'x)
  bitcount = count*8//2**64
  lowword = bitcount//2**32
  hiword = bitcount%2**32
  lowcount = lowword~d2c(4)~reverse -- make it little-endian
  hicount = hiword~d2c(4)~reverse   -- make it little-endian
  self~update(padding || lowcount || hicount)
return a0~string || b0~string || c0~string || d0~string

-- A convenience class to encapsulate operations on non OORexx-like
-- things as little-endian 32-bit words
::class int32 public

::attribute arch class

::method init class
  self~arch = "little-endian"   -- can be adapted for multiple architectures

-- Method to create an int32 like object
-- Input can be a OORexx whole number (type="I") or
-- a character string of 4 bytes (type="C")
-- input truncated or padded to 32-bit word/string
::method init
  expose char4 int32
  use strict arg input, type="Integer"
  -- type must be one of "I"nteger or "C"haracter
  t = type~subchar(1)~upper
  select
    when t=='I' then do
      char4 = input~d2c(4)
      int32 = char4~c2d
    end
    when t=='C' then do
      char4 = input~right(4,'00'x)
      int32 = char4~c2d
    end
    otherwise do
      raise syntax 93.915 array("IC",type)
    end
  end
exit

::method xor  -- wrapper for OORexx bitxor method
  expose char4
  use strict arg other
return .int32~new(char4~bitxor(other~char),"C")

::method and  -- wrapper for OORexx bitand method
  expose char4
  use strict arg other
return .int32~new(char4~bitand(other~char),"C")

::method or   -- wrapper for OORexx bitor method
  expose char4
  use strict arg other
return .int32~new(char4~bitor(other~char),"C")

::method bitleft -- OORexx shift (<<) implementation
  expose char4
  use strict arg bits
  bstring = char4~c2x~x2b
  bstring = bstring~substr(bits+1)~left(bstring~length,'0')
return .int32~new(bstring~b2x~x2d)

::method bitright -- OORexx shift (>>) implementation
  expose char4
  use strict arg bits, signed=.false
  bstring = char4~c2x~x2b
  fill = '0'
  if signed then fill = bstring~subchar(1)
  bstring = bstring~left(bstring~length-bits)~right(bstring~length,fill)
return .int32~new(bstring~b2x~x2d)

::method bitnot   -- OORexx not implementation
  expose char4
return .int32~new(char4~bitxor('ffffffff'x)~c2d,"C")

::method bitrotate  -- OORexx (left) rotate method
  expose char4
  use strict arg bits, direction='left'
  d = direction~subchar(1)~upper
  if d=='L' then do
    leftpart = self~bitleft(bits)
    rightpart = self~bitright(32-bits)
  end
  else do
    leftpart = self~bitleft(32-bits)
    rightpart = self~bitright(bits)
  end
return rightpart~or(leftpart)

::method int  -- retrieve integer as number
  expose int32
return int32

::method char -- retrieve integer as characters
  expose char4
return char4

::method '+'  -- OORexx method to add 2 .int32 instances
  expose int32
  use strict arg other
return .int32~new(int32+other~int)

::method string -- retrieve integer as hexadecimal string
  expose char4
return char4~reverse~c2x~lower

-- Simplify function names for the necessary 'RxMath' functions	
::routine sin EXTERNAL "LIBRARY rxmath RxCalcSin"

#!/usr/bin/env lua
-- ISAAC - Lua 5.3

-- External Results
local randRsl = {};
local randCnt = 0;

-- Internal State
local mm = {};
local aa,bb,cc = 0,0,0;

-- Cap to maintain 32 bit maths
local cap = 0x100000000;

-- CipherMode
local ENCRYPT = 1;
local DECRYPT = 2;

function isaac()

  cc = ( cc + 1  ) % cap; -- cc just gets incremented once per 256 results
  bb = ( bb + cc ) % cap; -- then combined with bb

  for i = 0,255 do
    local   x    = mm[i];
    local   y;
    local   imod = i % 4;
    if      imod == 0 then aa = aa ~ (aa << 13);
    elseif  imod == 1 then aa = aa ~ (aa >> 6);
    elseif  imod == 2 then aa = aa ~ (aa << 2);
    elseif  imod == 3 then aa = aa ~ (aa >> 16);
    end
    aa         = ( mm[(i+128)%256] + aa ) % cap;
    y          = ( mm[(x>>2) % 256] + aa + bb ) % cap;
    mm[i]      = y;
    bb         = ( mm[(y>>10)%256] + x ) % cap;
    randRsl[i] = bb;
  end

  randCnt = 0; -- Prepare to use the first set of results.

end

function mix(a)
  a[0] = ( a[0] ~ ( a[1] << 11 ) ) % cap;  a[3] = ( a[3] + a[0] ) % cap;  a[1] = ( a[1] + a[2] ) % cap;
  a[1] = ( a[1] ~ ( a[2] >>  2 ) ) % cap;  a[4] = ( a[4] + a[1] ) % cap;  a[2] = ( a[2] + a[3] ) % cap;
  a[2] = ( a[2] ~ ( a[3] <<  8 ) ) % cap;  a[5] = ( a[5] + a[2] ) % cap;  a[3] = ( a[3] + a[4] ) % cap;
  a[3] = ( a[3] ~ ( a[4] >> 16 ) ) % cap;  a[6] = ( a[6] + a[3] ) % cap;  a[4] = ( a[4] + a[5] ) % cap;
  a[4] = ( a[4] ~ ( a[5] << 10 ) ) % cap;  a[7] = ( a[7] + a[4] ) % cap;  a[5] = ( a[5] + a[6] ) % cap;
  a[5] = ( a[5] ~ ( a[6] >>  4 ) ) % cap;  a[0] = ( a[0] + a[5] ) % cap;  a[6] = ( a[6] + a[7] ) % cap;
  a[6] = ( a[6] ~ ( a[7] <<  8 ) ) % cap;  a[1] = ( a[1] + a[6] ) % cap;  a[7] = ( a[7] + a[0] ) % cap;
  a[7] = ( a[7] ~ ( a[0] >>  9 ) ) % cap;  a[2] = ( a[2] + a[7] ) % cap;  a[0] = ( a[0] + a[1] ) % cap;
end

function randInit(flag)

  -- The golden ratio in 32 bit
  -- math.floor((((math.sqrt(5)+1)/2)%1)*2^32) == 2654435769 == 0x9e3779b9
  local a = { [0] = 0x9e3779b9, 0x9e3779b9, 0x9e3779b9, 0x9e3779b9, 0x9e3779b9, 0x9e3779b9, 0x9e3779b9, 0x9e3779b9, };

  aa,bb,cc = 0,0,0;

  for i = 1,4 do  mix(a)  end -- Scramble it.

  for i = 0,255,8 do -- Fill in mm[] with messy stuff.
    if flag then -- Use all the information in the seed.
      for j = 0,7 do
        a[j] = ( a[j] + randRsl[i+j] ) % cap;
      end
    end
    mix(a);
    for j = 0,7 do
      mm[i+j] = a[j];
    end
  end

  if flag then
    -- Do a second pass to make all of the seed affect all of mm.
    for i = 0,255,8 do
      for j = 0,7 do
        a[j] = ( a[j] + mm[i+j] ) % cap;
      end
      mix(a);
      for j = 0,7 do
        mm[i+j] = a[j];
      end
    end
  end

  isaac(); -- Fill in the first set of results.
  randCnt = 0; -- Prepare to use the first set of results.

end

-- Seed ISAAC with a given string.
-- The string can be any size. The first 256 values will be used.
function seedIsaac(seed,flag)
  local seedLength = #seed;
  for i = 0,255 do mm[i] = 0; end
  for i = 0,255 do randRsl[i] = seed:byte(i+1,i+1) or 0; end
  randInit(flag);
end

-- Get a random 32-bit value 0..MAXINT
function getRandom32Bit()
  local result = randRsl[randCnt];
  randCnt = randCnt + 1;
  if randCnt > 255 then
    isaac();
    randCnt = 0;
  end
  return result;
end

-- Get a random character in printable ASCII range
function getRandomChar()
  return getRandom32Bit() % 95 + 32;
end

-- Convert an ASCII string to a hexadecimal string.
function ascii2hex(source)
  local ss = "";
  for i = 1,#source do
    ss = ss..string.format("%02X",source:byte(i,i));
  end
  return ss
end

-- XOR encrypt on random stream.
function vernam(msg)
  local msgLength = #msg;
  local destination = {};
  for i = 1, msgLength do
    destination[i] = string.char(getRandomChar() ~ msg:byte(i,i));
  end
  return table.concat(destination);
end

-- Caesar-shift a character <shift> places: Generalized Vigenere
function caesar(m, ch, shift, modulo, start)
  local n
  local si = 1
  if m == DECRYPT then shift = shift*-1 ; end
  n = (ch - start) + shift;
  if n < 0 then si,n = -1,n*-1 ; end
  n = ( n % modulo ) * si;
  if n < 0 then n = n + modulo ; end
  return start + n;
end

-- Vigenere mod 95 encryption & decryption.
function vigenere(msg,m)
  local msgLength = #msg;
  local destination = {};
  for i = 1,msgLength do
    destination[i] = string.char( caesar(m, msg:byte(i,i), getRandomChar(), 95, 32) );
  end
  return table.concat(destination);
end

function main()
  local msg = "a Top Secret secret";
  local key = "this is my secret key";
  local xorCipherText, modCipherText, xorPlainText, modPlainText;

  -- (1) Seed ISAAC with the key
  seedIsaac(key, true);
  -- (2) Encryption
  -- (a) XOR (Vernam)
  xorCipherText = vernam(msg);
  -- (b) MOD (Vigenere)
  modCipherText = vigenere(msg, ENCRYPT);
  -- (3) Decryption
  seedIsaac(key, true);
  -- (a) XOR (Vernam)
  xorPlainText = vernam(xorCipherText);
  -- (b) MOD (Vigenere)
  modPlainText = vigenere(modCipherText, DECRYPT);
  -- Program output
  print("Message: " .. msg);
  print("Key    : " .. key);
  print("XOR    : " .. ascii2hex(xorCipherText));
  print("XOR dcr: " .. xorPlainText);
  print("MOD    : " .. ascii2hex(modCipherText));
  print("MOD dcr: " .. modPlainText);

end

main()

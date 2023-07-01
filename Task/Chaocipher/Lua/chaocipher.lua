-- Chaocipher, in Lua, 6/19/2020 db
local Chaocipher = {
  ct = "HXUCZVAMDSLKPEFJRIGTWOBNYQ",
  pt = "PTLNBQDEOYSFAVZKGJRIHWXUMC",
  encrypt = function(self, text) return self:_encdec(text, true) end,
  decrypt = function(self, text) return self:_encdec(text, false) end,
  _encdec = function(self, text, encflag)
    local ct, pt, s = self.ct, self.pt, ""
    local cshl = function(s,i) return s:sub(i) .. s:sub(1,i-1) end
    local sshl = function(s,i) return s:sub(1,i-1) .. s:sub(i+1,14) .. s:sub(i,i) .. s:sub(15) end
    for ch in text:gmatch(".") do
      local i = (encflag and pt or ct):find(ch)
      s = s .. (encflag and ct or pt):sub(i,i)
      if encflag then print(ct, pt, ct:sub(i,i), pt:sub(i,i)) end
      ct, pt = sshl(cshl(ct, i), 2), sshl(cshl(pt, i+1), 3)
    end
    return s
  end,
}
local plainText = "WELLDONEISBETTERTHANWELLSAID"
local encryptText = Chaocipher:encrypt(plainText)
local decryptText = Chaocipher:decrypt(encryptText)
print()
print("The original text was:  " .. plainText)
print("The encrypted text is:  " .. encryptText)
print("The decrypted text is:  " .. decryptText)

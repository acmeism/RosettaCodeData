function stripchars(str, chrs)
  local s = str:gsub("["..chrs:gsub("%W","%%%1").."]", '')
  return s
end

print( stripchars( "She was a soul stripper. She took my heart!", "aei" ) )
--> Sh ws  soul strppr. Sh took my hrt!
print( stripchars( "She was a soul stripper. She took my heart!", "a-z" ) )
--> She ws  soul stripper. She took my hert!

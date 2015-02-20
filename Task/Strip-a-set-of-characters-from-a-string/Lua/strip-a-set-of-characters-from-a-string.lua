function stripchars(str, chrs)
  local s = str:gsub("["..chrs.."]", '')
  return s
end

print( stripchars( "She was a soul stripper. She took my heart!", "aei" ) )

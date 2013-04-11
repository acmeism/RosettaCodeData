to rot13(textString)
  local outChars
  set outChars to {}
  repeat with ch in (characters of textString)
    if (ch >= "a" and ch <= "m") or (ch >= "A" and ch <= "M") then
      set ch to character id (id of ch + 13)
    else if (ch >= "n" and ch <= "z") or (ch >= "N" and ch <= "Z") then
      set ch to character id (id of ch - 13)
    end
    set end of outChars to ch
  end
  return outChars as text
end rot13

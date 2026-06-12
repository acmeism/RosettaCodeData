for word in io.lines("unixdict.txt") do
  if #word > 11 and word:find("the") then
    print(word)
  end
end

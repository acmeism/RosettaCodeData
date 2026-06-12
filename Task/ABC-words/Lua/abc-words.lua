for word in io.lines('unixdict.txt') do
  if string.find(word, "^[^bc]*a[^c]*b.*c") then
    print(word)
  end
end

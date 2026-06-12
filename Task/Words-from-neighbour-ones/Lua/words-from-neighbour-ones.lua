wordlist, wordhash = {}, {}
for word in io.open("unixdict.txt", "r"):lines() do
  if #word >= 9 then
    wordlist[#wordlist+1] = word
    wordhash[word] = #wordlist
  end
end
for n = 1, #wordlist-8 do
  local word = ""
  for i = 0, 8 do
    word = word .. wordlist[n+i]:sub(i+1,i+1)
  end
  if wordhash[word] then
    -- task appears to say "for every n, do all of the following"
    -- but doesn't appear to say "..unless a duplicate"
    -- so, intentionally verbose/redundant:
    print(word)
  end
end

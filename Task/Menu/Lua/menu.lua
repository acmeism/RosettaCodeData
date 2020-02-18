function select (list)
   if not list or #list == 0 then
      return ""
   end
   local last, sel = #list
   repeat
      for i,option in ipairs(list) do
         io.write(i, ". ", option, "\n")
      end
      io.write("Choose an item (1-", tostring(last), "): ")
      sel = tonumber(string.match(io.read("*l"), "^%d+$"))
   until type(sel) == "number" and sel >= 1 and sel <= last
   return list[math.floor(sel)]
end

print("Nothing:", select {})
print()
print("You chose:", select {"fee fie", "huff and puff", "mirror mirror", "tick tock"})

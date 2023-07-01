function sierpinski(depth)
   lines = {}
   lines[1] = '*'

   for i = 2, depth+1 do
      sp = string.rep(' ', 2^(i-2))
      tmp = {}
      for idx, line in ipairs(lines) do
         tmp[idx] = sp .. line .. sp
         tmp[idx+#lines] = line .. ' ' .. line
      end
      lines = tmp
   end
   return table.concat(lines, '\n')
end

print(sierpinski(4))

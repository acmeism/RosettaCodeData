function luhn_test(cc_number)
   assert(type(cc_number) == 'string')
   local sum = 0
   local is_odd = true
   for idx = #cc_number , 1 , -1 do  -- reverse order
      -- extract single character as string then convert to integer
      local digit = cc_number:sub(idx, idx) + 0
      if is_odd then
         sum = sum + digit
      else
         sum = sum + ((digit * 2) % 10) + (digit // 5)
      end  -- if
      is_odd = not is_odd  -- toggle between odd and even
   end  -- for
   return (sum % 10) == 0
end  -- function luhn_test

for _, val in ipairs{"49927398716", "49927398717", "1234567812345678", "1234567812345670"} do
   print(val, luhn_test(val))
end  -- for

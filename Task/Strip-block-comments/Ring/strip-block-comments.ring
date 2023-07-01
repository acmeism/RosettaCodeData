example = "123/*456*/abc/*def*/789"

example2 = example
nr = 1
while nr = 1
      n1 = substr(example2,"/*")
      n2 = substr(example2,"*/")
      if n1 > 0 and n2 > 0
         example3 = substr(example2,n1,n2-n1+2)
         example2 = substr(example2,example3,"")
      else nr = 0 ok
end
see example2 + nl

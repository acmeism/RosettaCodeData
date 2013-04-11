digits = "0123456789abcdefghijklmnopqrstuvwxyz"
def baseN(num,b):
   return (((num == 0) and  "0" )
           or ( baseN(num // b, b).lstrip("0")
                + digits[num % b]))

# alternatively:
def baseN(num,b):
  if num == 0: return "0"
  result = ""
  while num != 0:
    num, d = divmod(num, b)
    result += digits[d]
  return result[::-1] # reverse

k = 26
s = baseN(k,16) # returns the string 1a

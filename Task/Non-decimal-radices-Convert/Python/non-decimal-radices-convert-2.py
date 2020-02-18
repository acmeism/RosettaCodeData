digits = "0123456789abcdefghijklmnopqrstuvwxyz"
def baseN(num,b):
   return (((num == 0) and  "0" )
           or ( baseN(num // b, b).lstrip("0")
                + digits[num % b]))

>>> def vérifLuhn(ch):
  sum = 0
  chParity = len(ch) % 2
  for i in range (len(ch)-1, -1, -1):
    j = int(ch[i])
    if ((i + 1) % 2 != chParity):
      j = j * 2
    if (j > 9):
      j = j - 9
    sum = sum + j
  print("value calculated = ", str(sum))
  return sum % 10 == 0

for n in (49927398716, 49927398717, 1234567812345678, 1234567812345670):
        print (str(n)+" =>", vérifLuhn(str(n)))

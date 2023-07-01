def p_loop():
  import re, string
  re1=""       # Beginning of Regex
  re2=""       # End of Regex
  pal=raw_input("Please Enter a word or phrase: ")
  pd = pal.replace(' ','')
  for c in string.punctuation:
     pd = pd.replace(c,"")
  if pal == "" :
    return -1
  c=len(pd)   # Count of chars.
  loops = (c+1)/2
  for x in range(loops):
    re1 = re1 + "(\w)"
    if (c%2 == 1 and x == 0):
       continue
    p = loops - x
    re2 = re2 + "\\" + str(p)
  regex= re1+re2+"$"   # regex is like "(\w)(\w)(\w)\2\1$"
  #print(regex)  # To test regex before re.search
  m = re.search(r'^'+regex,pd,re.IGNORECASE)
  if (m):
     print("\n   "+'"'+pal+'"')
     print("   is a Palindrome\n")
     return 1
  else:
     print("Nope!")
     return 0

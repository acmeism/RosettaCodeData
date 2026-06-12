/* REXX */
s="123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
Numeric Digits 100
k='00010966776006953D5567439E5E39F86A0D273BEED61967F6'x
n=c2d(k)
o=''
Do Until n=0
  rem=n//58
  n=n%58
  o=o||substr(s,rem+1,1)
  End
o=o||substr(s,1,1)
Say reverse(o)

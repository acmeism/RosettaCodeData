n=2
s=HI
t:=&s
While *t
o.=Chr(Mod(*t-65+n,26)+65),t+=2
MsgBox % o

MsgBox % ToBase(29,3)
MsgBox % ToBase(255,16)

MsgBox % FromBase("100",8)
MsgBox % FromBase("ff",16)

ToBase(n,b) { ; n >= 0, 1 < b <= 36
   Return (n < b ? "" : ToBase(n//b,b)) . ((d:=mod(n,b)) < 10 ? d : Chr(d+87))
}

FromBase(s,b) { ; convert base b number s=strings of 0..9,a..z, to AHK number
   Return (L:=StrLen(s))=0 ? "":(L>1 ? FromBase(SubStr(s,1,L-1),b)*b:0) + ((c:=Asc(SubStr(s,0)))>57 ? c-87:c-48)
}

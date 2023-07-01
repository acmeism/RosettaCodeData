STRING s := "12345"; FILE f; INT i;
associate(f, s); get(f,i);
i+:=1;
s:=""; reset(f); put(f,i);
print((s, new line))

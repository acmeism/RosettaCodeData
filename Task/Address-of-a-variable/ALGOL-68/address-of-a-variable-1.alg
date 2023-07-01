[4]INT test := (222,444,666,888);
REF INT reference := test[3];
REF INT(reference) := reference + 111;
print(("test value is now: ",test))

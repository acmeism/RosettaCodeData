code='print(("Hello", new line))'
a=/tmp/algol$$ s=/usr/share/algol68toc;
echo -e "PROGRAM algol$$ CONTEXT VOID\nUSE standard\nBEGIN\n$code\nEND\nFINISH\n" > $a.a68 &&
a68toc -lib $s -dir $s -uname TMP -tmp $a.a68 && rm $a.a68 &&
gcc $s/Afirst.o $a.c  -l{a68s,a68,m,c} -o $a && rm $a.c &&
$a; rm $a

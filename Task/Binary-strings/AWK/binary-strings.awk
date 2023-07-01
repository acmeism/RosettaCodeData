#!/usr/bin/awk -f

BEGIN {
	# string creation
	a="123\0 abc ";
	b="456\x09";
	c="789";
	printf("abc=<%s><%s><%s>\n",a,b,c);

	# string comparison
	printf("(a==b) is %i\n",a==b)

	# string copying
	A = a;
	B = b;
	C = c;
	printf("ABC=<%s><%s><%s>\n",A,B,C);

	# check if string is empty
	if (length(a)==0) {
		printf("string a is empty\n");
	} else {
		printf("string a is not empty\n");
	}

	# append a byte to a string
	a=a"\x40";
	printf("abc=<%s><%s><%s>\n",a,b,c);

	# substring
	e = substr(a,1,6);
	printf("substr(a,1,6)=<%s>\n",e);

	# join strings
	d=a""b""c;
	printf("d=<%s>\n",d);
}

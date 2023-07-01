	a=['123',0,' abc '];
	b=['456',9];
	c='789';
	disp(a);
	disp(b);
	disp(c);

	% string comparison
	printf('(a==b) is %i\n',strcmp(a,b));

	% string copying
	A = a;
	B = b;
	C = c;
	disp(A);
	disp(B);
	disp(C);

	% check if string is empty
	if (length(a)==0)
		printf('\nstring a is empty\n');
	else
		printf('\nstring a is not empty\n');
	end

	% append a byte to a string
	a=[a,64];
        disp(a);

	% substring
	e = a(1:6);
        disp(e);

	% join strings
	d=[a,b,c];
	disp(d);

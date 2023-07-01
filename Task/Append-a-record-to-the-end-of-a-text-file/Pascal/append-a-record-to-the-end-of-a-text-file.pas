program appendARecordToTheEndOfATextFile;

var
	passwd: bindable text;
	FD: bindingType;

begin
	{ initialize FD }
	FD := binding(passwd);
	FD.name := '/tmp/passwd';
	
	{ attempt opening file [e.g. effective user has proper privileges?] }
	bind(passwd, FD);
	
	{ query binding state of `passwd` }
	FD := binding(passwd);
	
	if not FD.bound then
	begin
		writeLn('Error: could not open ', FD.name);
		halt;
	end;
	
	{ open for overwriting }
	rewrite(passwd);
	writeLn(passwd, 'jsmith:x:1001:1000:Joe Smith,Room 1007,(234)555-8917,(234)555-0077,jsmith@rosettacode.org:/home/jsmith:/bin/bash');
	writeLn(passwd, 'jdoe:x:1002:1000:Jane Doe,Room 1004,(234)555-8914,(234)555-0044,jdoe@rosettacode.org:/home/jdoe:/bin/bash');
	
	{ close }
	unbind(passwd);
	
	{ rebind }
	bind(passwd, FD);
	FD := binding(passwd);
	
	if not FD.bound then
	begin
		writeLn('Error: could not reopen ', FD.name);
		halt;
	end;
	
	{ open in append/writable mode }
	extend(passwd);
	
	{ write another record to file }
	writeLn(passwd, 'xyz:x:1003:1000:X Yz,Room 1003,(234)555-8913,(234)555-0033,xyz@rosettacode.org:/home/xyz:/bin/bash');
end.

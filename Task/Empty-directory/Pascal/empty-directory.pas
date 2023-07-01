program emptyDirectory(input, output);

type
	path = string(1024);

{
	\brief determines whether a (hierarchial FS) directory is empty
	
	\param accessVia a possible route to access a directory
	\return whether \param accessVia is an empty directory
}
function isEmptyDirectory(protected accessVia: path): Boolean;
var
	{ NB: `file` data types without a domain type are non-standard }
	directory: bindable file;
	FD: bindingType;
begin
	{ initialize variables }
	unbind(directory);
	FD := binding(directory);
	
	FD.name := accessVia;
	{ binding to directories is usually not possible }
	FD.force := true;
	
	{ the actual test }
	bind(directory, FD);
	FD := binding(directory);
	unbind(directory);
	
	isEmptyDirectory := FD.bound and FD.directory and (FD.links <= 2)
end;

{ === MAIN ============================================================= }
var
	s: path;
begin
	readLn(s);
	writeLn(isEmptyDirectory(s))
end.

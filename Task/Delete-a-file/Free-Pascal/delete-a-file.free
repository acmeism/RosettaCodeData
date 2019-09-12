program deletion(input, output, stdErr);
const
	rootDirectory = '/'; // might have to be altered for other platforms
	inputTextFilename = 'input.txt';
	docsFilename = 'docs';
var
	fd: file;
begin
	assign(fd, inputTextFilename);
	erase(fd);
	
	rmDir(docsFilename);
	
	assign(fd, rootDirectory + inputTextFilename);
	erase(fd);
	
	rmDir(rootDirectory + docsFilename);
end.

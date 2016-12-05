define file_truncate(path::string, size::integer) => {

	local(file = file(#path))

	fail_if(not(#file -> exists), -1, 'There is no file at the given path')
	fail_if(#file -> size < #size, -1, 'No point in truncating a file to a larger size than it already is')

	#file -> setSize(#size)

}
local(filepath = '//Library/WebServer/Documents/Lasso9cli/trunk/testing/lorem_ipsum_long.txt')

stdoutnl(file(#filepath) -> readbytes)
stdoutnl('Original size: ' + file(#filepath) -> size)

file_truncate(#filepath, 300)

stdoutnl(file(#filepath) -> readbytes)
stdout(file('Truncated size: ' + #filepath) -> size)

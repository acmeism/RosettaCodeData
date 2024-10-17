integer fn

-- In the current working directory
system("mkdir docs",2)
fn = open("output.txt","w")
close(fn)

-- In the filesystem root
system("mkdir \\docs",2)
fn = open("\\output.txt","w")
close(fn)

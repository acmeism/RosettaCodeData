fn1 = "ReadMe.txt"
fn2 = "ReadMe2.txt"

fp = fopen(fn1,"r")
str = fread(fp, getFileSize(fp))
fclose(fp)

fp = fopen(fn2,"w")
fwrite(fp, str)
fclose(fp)
see "OK" + nl

func getFileSize fp
     c_filestart = 0
     c_fileend = 2
     fseek(fp,0,c_fileend)
     nfilesize = ftell(fp)
     fseek(fp,0,c_filestart)
     return nfilesize

filenames = ["ReadMe.txt", "ReadMe2.txt"]

for fn in filenames
    fp = fopen(fn,"r")
    str = fread(fp,getFileSize(fp))
    str = substr(str, "Greetings", "Hello")
    fclose(fp)

    fp = fopen(fn,"w")
    fwrite(fp, str)
    fclose(fp)
next

func getFileSize fp
     C_FILESTART = 0
     C_FILEEND = 2
     fseek(fp,0,C_FILEEND)
     nFileSize = ftell(fp)
     fseek(fp,0,C_FILESTART)
     return nFileSize

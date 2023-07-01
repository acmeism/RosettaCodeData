file = "C:\Ring\ReadMe.txt"
fp = read(file)
fpstr = left(fp, 100)
see fpstr + nl
write(file, fpstr)

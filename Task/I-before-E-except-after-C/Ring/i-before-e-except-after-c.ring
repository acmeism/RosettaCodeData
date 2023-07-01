# Project : I before E except after C

fn1 = "unixdict.txt"

fp = fopen(fn1,"r")
str = fread(fp, getFileSize(fp))
fclose(fp)
strcount = str2list(str)
see "The number of words in unixdict : " + len(strcount) + nl
cei = count(str, "cei")
cie = count(str, "cie")
ei = count(str, "ei")
ie = count(str, "ie")
see "Instances of cei : " + cei + nl
see "Instances of cie : " + cie + nl
see "Rule: 'e' before 'i' when preceded by 'c' is = "
if cei>cie see "plausible" + nl else see"not plausible" + nl ok
see "Instances of *ei, where * is not c : " + (ei-cei) + nl
see "Instances of *ie, where * is not c: " + (ie-cie) + nl
see "Rule: 'i' before 'e' when not preceded by 'c' is = "
if ie>ei see "plausible" + nl else see "not plausible" + nl ok
see "Overall the rule is : "
if cei>cie and ie>ei see "PLAUSIBLE" + nl else see "NOT PLAUSIBLE" + nl ok

func getFileSize fp
       c_filestart = 0
       c_fileend = 2
       fseek(fp,0,c_fileend)
       nfilesize = ftell(fp)
       fseek(fp,0,c_filestart)
       return nfilesize

func count(cString,dString)
       sum = 0
       while substr(cString,dString) > 0
               sum = sum + 1
               cString = substr(cString,substr(cString,dString)+len(string(sum)))
       end
       return sum

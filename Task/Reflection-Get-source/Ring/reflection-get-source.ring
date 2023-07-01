# Project : Reflection/Get source

fp = fopen("C:\Ring\applications\fifteenpuzzle\CalmoSoftFifteenPuzzleGame.ring","r")
r = ""
str = ""
flag = 0
numline = 0
see "give the function: "
give funct
funct = "func " + funct
while isstring(r)
        r = fgetc(fp)
        if r = char(10)
           flag = 1
           numline = numline + 1
        else
           flag = 0
           str = str + r
        ok
        if flag = 1
           if left(str,len(funct)) = funct
              see '"' + funct + '"' +" is in the line: " + numline + nl
           ok
           str = ""
        ok
end
fclose(fp)

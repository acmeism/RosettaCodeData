# Project : Write float arrays to a text file

decimals(13)
x = [1, 2, 3, 100000000000]
y = [1, 1.4142135623730, 1.7320508075688, 316227.76601683]
str = list(4)
fn = "C:\Ring\calmosoft\output.txt"
fp = fopen(fn,"wb")
for i = 1 to 4
     str[i] = string(x[i]) + " | " + string(y[i]) + windowsnl()
     fwrite(fp, str[i])
next
fclose(fp)
fp = fopen("C:\Ring\calmosoft\output.txt","r")
r = ""
while isstring(r)
        r = fgetc(fp)
        if r = char(10) see nl
        else see r ok
end
fclose(fp)

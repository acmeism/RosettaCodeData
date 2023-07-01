# project : Word count

fp = fopen("Miserables.txt","r")
str = fread(fp, getFileSize(fp))
fclose(fp)

mis =substr(str, " ", nl)
mis = lower(mis)
mis = str2list(mis)
count = list(len(mis))
ready = []
for n = 1 to len(mis)
     flag = 0
     for m = 1 to len(mis)
           if mis[n] = mis[m] and n != m
              for p = 1 to len(ready)
                    if m = ready[p]
                       flag = 1
                    ok
              next
              if flag = 0
                 count[n] = count[n] + 1
              ok
           ok
     next
     if flag = 0
        add(ready, n)
     ok
next
for n = 1 to len(count)
     for m = n + 1 to len(count)
          if count[m] > count[n]
             temp = count[n]
             count[n] = count[m]
             count[m] = temp
             temp = mis[n]
             mis[n] = mis[m]
             mis[m] = temp
          ok
     next
next
for n = 1 to 10
     see mis[n] + " " + (count[n] + 1) + nl
next

func getFileSize fp
        c_filestart = 0
        c_fileend = 2
        fseek(fp,0,c_fileend)
        nfilesize = ftell(fp)
        fseek(fp,0,c_filestart)
        return nfilesize

func swap(a, b)
        temp = a
        a = b
        b = temp
        return [a, b]

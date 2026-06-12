nums = [[2,5,1,3,8,9,4,6],[3,5,6,2,9,8,4],[1,3,7,6,9]]
sumNums = []
result = []

for n = 1 to len(nums)
    for m = 1 to len(nums[n])
        add(sumNums,nums[n][m])
    next
next

sumNums = sort(sumNums)
for n = len(sumNums) to 2 step -1
    if sumNums[n] = sumNums[n-1]
       del(sumNums,n)
    ok
next

for n = 1 to len(sumNums)
    flag = list(len(nums))
    for m = 1 to len(nums)
        flag[m] = 1
        ind = find(nums[m],sumNums[n])
        if ind < 1
           flag[m] = 0
        ok
    next
    flagn = 1
    for p = 1 to len(nums)
        if flag[p] = 1
           flagn = 1
        else
           flagn = 0
           exit
        ok
    next
    if flagn = 1
       add(result,sumNums[n])
    ok
next

see "common list elements are: "
showArray(result)

func showArray(array)
     txt = ""
     see "["
     for n = 1 to len(array)
         txt = txt + array[n] + ","
     next
     txt = left(txt,len(txt)-1)
     txt = txt + "]"
     see txt

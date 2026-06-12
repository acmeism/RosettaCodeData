nums = [[5,1,3,8,9,4,8,7],[3,5,9,8,4],[1,3,7,9]]
sumNums = []

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

sumNums = sort(sumNums)

see "common sorted list elements are: "
showArray(sumNums)

func showArray(array)
     txt = ""
     see "["
     for n = 1 to len(array)
         txt = txt + array[n] + ","
     next
     txt = left(txt,len(txt)-1)
     txt = txt + "]"
     see txt

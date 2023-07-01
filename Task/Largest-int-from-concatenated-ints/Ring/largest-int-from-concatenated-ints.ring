nums=[1,34,3,98,9,76,45,4]
see largestInt(8) + nl
nums=[54,546,548,60]
see largestInt(4) + nl

func largestInt len
l = ""
sorted = false
while not sorted
      sorted=true
      for i=1 to len-1
          a=string(nums[i])
          b=string(nums[i+1])
          if a+b<b+a
             temp = nums[i]
             nums[i] = nums[i+1]
             nums[i+1] = temp
             sorted=false ok
      next
end
for i=1 to len
    l+=string(nums[i])
next
return l

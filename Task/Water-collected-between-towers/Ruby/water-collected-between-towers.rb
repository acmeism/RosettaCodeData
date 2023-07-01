def a(array)
n=array.length
left={}
right={}
left[0]=array[0]
i=1
loop do
   break if i >=n
left[i]=[left[i-1],array[i]].max
   i += 1
end
right[n-1]=array[n-1]
i=n-2
loop do
break if i<0
 right[i]=[right[i+1],array[i]].max
i-=1
end
i=0
water=0
loop do
break if i>=n
water+=[left[i],right[i]].min-array[i]
i+=1
end
puts water
end

a([ 5, 3,  7, 2, 6, 4, 5, 9, 1, 2 ])
a([ 2, 6,  3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1 ])
a([ 5, 5,  5, 5 ])
a([ 5, 6,  7, 8 ])
a([ 8, 7,  7, 6 ])
a([ 6, 7, 10, 7, 6 ])
return

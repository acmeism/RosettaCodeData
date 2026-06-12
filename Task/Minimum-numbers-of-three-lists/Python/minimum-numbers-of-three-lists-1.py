numbers1 = [5,45,23,21,67]
numbers2 = [43,22,78,46,38]
numbers3 = [9,98,12,98,53]

numbers = [min(numbers1[i],numbers2[i],numbers3[i]) for i in range(0,len(numbers1))]

print(numbers)

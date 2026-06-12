Red [
    Red-version: 0.6.4
    Description: "Find the element-wise minimum of three lists"
]

numbers1: [5 45 23 21 67]
numbers2: [43 22 78 46 38]
numbers3: [9 98 12 98 53]
length: length? numbers1
result: append/dup [] 0 length
repeat i length [
    result/:i: min min numbers1/:i numbers2/:i numbers3/:i
]
print result

arr1: []      ;create empty array
arr2: ["apple" "orange" 1 2 3]    ;create an array with data
>> insert arr1 "blue"
>> arr1
== ["blue"]
append append arr1 "black" "green"
>> arr1
== ["blue" "black" "green"]
>> arr1/2
== "black"
>> second arr1
== "black"
>> pick arr1 2
== "black"

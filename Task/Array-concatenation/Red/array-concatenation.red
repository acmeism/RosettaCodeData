>> arr1: ["a" "b" "c"]
>> arr2: ["d" "e" "f"]
>> append arr1 arr2
== ["a" "b" "c" "d" "e" "f"]
>> arr3: [1 2 3]
>> insert arr1 arr3
>> arr1
== [1 2 3 "a" "b" "c" "d" "e" "f"]
>> arr4: [22 33 44]
== [22 33 44]
>> append/only arr1 arr4
== [1 2 3 "a" "b" "c" "d" "e" "f" [22 33 44]]

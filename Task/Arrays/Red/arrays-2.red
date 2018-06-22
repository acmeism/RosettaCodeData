>> vec1: make vector! [ 20 30 70]
== make vector! [20 30 70]
>> vec1/2
== 30
>> second vec1
== 30
>> append vec1 90
== make vector! [20 30 70 90]
>> append vec1 "string"
*** Script Error: invalid argument: "string"
*** Where: append
*** Stack:
>> append vec1 3.0
*** Script Error: invalid argument: 3.0
*** Where: append
*** Stack:

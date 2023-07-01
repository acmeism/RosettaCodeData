f0=: [: smoutput 'neither option: ' , ":
f1=: [: smoutput 'first option: ' , ":
f2=: [: smoutput 'second option: ' , ":
f3=: [: smoutput 'both options: ' , ":

isprime=: 1&p:
iseven=: 0 = 2&|

   f0`f1`f2`f3 if2 (isprime`iseven)"0 i.5
second option: 0
neither option: 1
both options: 2
first option: 3
second option: 4

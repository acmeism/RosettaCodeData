>> myLIFO = LIFOQueue(1,'fish',2,'fish','red fish','blue fish')

myLIFO =

	LIFOQueue

>> myLIFO.pop()

ans =

blue fish

>> myLIFO.push('Cat Fish')
>> myLIFO.pop()

ans =

Cat Fish

>> myLIFO.pop()

ans =

red fish

>> empty(myLIFO)

ans =

     0

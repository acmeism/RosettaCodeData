>>> try: raw_input
except NameError: raw_input = input

>>> for i in range(int(raw_input())):
	print(sum(int(numberstring)
		  for numberstring
		  in raw_input().strip().split()))

	
5
1 2
3
10 20
30
-3 5
2
100 2
102
5 5
10
>>>

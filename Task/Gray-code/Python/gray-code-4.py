>>> for i in range(16):
	print('int:%2i -> bin:%12r -> gray:%12r -> bin:%12r -> int:%2i' %
	      ( i,
	        int2bin(i),
	        bin2gray(int2bin(i)),
	        gray2bin(bin2gray(int2bin(i))),
	        bin2int(gray2bin(bin2gray(int2bin(i))))
	      ))

	
int: 0 -> bin:         [0] -> gray:         [0] -> bin:         [0] -> int: 0
int: 1 -> bin:         [1] -> gray:         [1] -> bin:         [1] -> int: 1
int: 2 -> bin:      [1, 0] -> gray:      [1, 1] -> bin:      [1, 0] -> int: 2
int: 3 -> bin:      [1, 1] -> gray:      [1, 0] -> bin:      [1, 1] -> int: 3
int: 4 -> bin:   [1, 0, 0] -> gray:   [1, 1, 0] -> bin:   [1, 0, 0] -> int: 4
int: 5 -> bin:   [1, 0, 1] -> gray:   [1, 1, 1] -> bin:   [1, 0, 1] -> int: 5
int: 6 -> bin:   [1, 1, 0] -> gray:   [1, 0, 1] -> bin:   [1, 1, 0] -> int: 6
int: 7 -> bin:   [1, 1, 1] -> gray:   [1, 0, 0] -> bin:   [1, 1, 1] -> int: 7
int: 8 -> bin:[1, 0, 0, 0] -> gray:[1, 1, 0, 0] -> bin:[1, 0, 0, 0] -> int: 8
int: 9 -> bin:[1, 0, 0, 1] -> gray:[1, 1, 0, 1] -> bin:[1, 0, 0, 1] -> int: 9
int:10 -> bin:[1, 0, 1, 0] -> gray:[1, 1, 1, 1] -> bin:[1, 0, 1, 0] -> int:10
int:11 -> bin:[1, 0, 1, 1] -> gray:[1, 1, 1, 0] -> bin:[1, 0, 1, 1] -> int:11
int:12 -> bin:[1, 1, 0, 0] -> gray:[1, 0, 1, 0] -> bin:[1, 1, 0, 0] -> int:12
int:13 -> bin:[1, 1, 0, 1] -> gray:[1, 0, 1, 1] -> bin:[1, 1, 0, 1] -> int:13
int:14 -> bin:[1, 1, 1, 0] -> gray:[1, 0, 0, 1] -> bin:[1, 1, 1, 0] -> int:14
int:15 -> bin:[1, 1, 1, 1] -> gray:[1, 0, 0, 0] -> bin:[1, 1, 1, 1] -> int:15
>>>

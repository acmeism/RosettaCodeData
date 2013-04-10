include ffl/car.fs

10 car-create ar           \ create a dynamic array with initial size 10

2 0 ar car-set             \ ar[0] = 2
3 1 ar car-set             \ ar[1] = 3
1 0 ar car-insert          \ ar[0] = 1 ar[1] = 2 ar[2] = 3

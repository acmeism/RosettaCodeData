   Filter =: (#~`)(`:6)

   B =: *: A =: i. >: i. 2200

   S1 =: , B +/ B             NB. S1 is a raveled table of the sums of squares
   S1 =: <:&({:B)Filter S1    NB. remove sums of squares exceeding bound
   S1 =: ~. S1                NB. remove duplicate entries

   S2 =: , B +/ S1
   S2 =: <:&({:B)Filter S2
   S2 =: ~. S2

   RESULT =: (B -.@:e. S2) # A
   RESULT
1 2 4 5 8 10 16 20 32 40 64 80 128 160 256 320 512 640 1024 1280 2048

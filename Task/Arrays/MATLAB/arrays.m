>> a = [1 2 35] %Declaring a vector (i.e. one-dimensional array)

a =

     1     2    35

>> a = [1 2 35;5 7 9] % Declaring a matrix (i.e. two-dimensional array)

a =

     1     2    35
     5     7     9

>> a3 = reshape(1:2*3*4,[2,3,4]);   % declaring a three-dimensional array of size 2x3x4

a3 =

ans(:,:,1) =

   1   3   5
   2   4   6

ans(:,:,2) =

    7    9   11
    8   10   12

ans(:,:,3) =

   13   15   17
   14   16   18

ans(:,:,4) =

   19   21   23
   20   22   24


>> a(2,3) %Retrieving value using row and column indicies

     9

>> a(6) %Retrieving value using array subscript

ans =

     9

>> a = [a [10;42]] %Added a column vector to the array

a =

     1     2    35    10
     5     7     9    42

>> a(:,1) = [] %Deleting array elements

a =

     2    35    10
     7     9    42

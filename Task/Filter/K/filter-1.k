   / even is a boolean function
   even:{0=x!2}
   even 1 2 3 4 5
0 1 0 1 0

   / filtering the even numbers
   a@&even'a:1+!10
2 4 6 8 10

   / as a function
   evens:{x@&even'x}
   a:10?100
45 5 79 77 44 15 83 88 33 99
   evens a
44 88

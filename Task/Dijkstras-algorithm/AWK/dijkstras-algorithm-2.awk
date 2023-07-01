$ cat dijkstra.txt
a b 7
a c 9
a f 14
b c 10
b d 15
c d 11
c f 2
d e 6
e f 9
a e
a f
f a

$ awk -f dijkstra.awk dijkstra.txt
a-c-d-e (26)
a-c-f (11)
f-a (n/a)

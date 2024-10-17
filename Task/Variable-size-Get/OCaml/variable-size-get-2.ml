# sizeof 234 ;;
- : int = 1

# sizeof 23.4 ;;
- : int = 2

# sizeof (1,2);;
- : int = 3

# sizeof (2, 3.4) ;;
- : int = 4

# sizeof (1,2,3,4,5) ;;
- : int = 6

# sizeof [| 1;2;3;4;5 |] ;;
- : int = 6

# sizeof [1;2;3;4;5] ;;
- : int = 11

(* because a list is equivalent to *)

# sizeof (1,(2,(3,(4,(5,0))))) ;;
- : int = 11

# type foo = A | B of int | C of int * int ;;
type foo = A | B of int | C of int * int

# sizeof A ;;
- : int = 1

# sizeof (B 3) ;;
- : int = 2

# sizeof (C(1,2)) ;;
- : int = 3

# sizeof true ;;
- : int = 1

# sizeof 'A' ;;
- : int = 1

# sizeof `some_pvar ;;
- : int = 1

# sizeof "" ;;
- : int = 1

# sizeof "Hello!" ;;
- : int = 2
(* remember the size is given in words
   (so 4 octets on 32 bits machines) *)

# for i=0 to 16 do
    Printf.printf "%d -> %d\n" i (sizeof(String.create i))
  done;;
0 -> 1
1 -> 1
2 -> 1
3 -> 1
4 -> 2
5 -> 2
6 -> 2
7 -> 2
8 -> 3
9 -> 3
10 -> 3
11 -> 3
12 -> 4
13 -> 4
14 -> 4
15 -> 4
16 -> 5
- : unit = ()

# sizeof(Array.create 10 0) ;;
- : int = 11

# sizeof(Array.create 10 (String.create 20)) ;;
- : int = 16

# sizeof(Array.init 10 (fun _ -> String.create 20)) ;;
- : int = 61

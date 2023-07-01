: (mapc println (1 2 3 4 5))  # Print numbers
1
2
3
4
5
-> 5

: (mapcar '((N) (* N N)) (1 2 3 4 5))  # Calculate squares
-> (1 4 9 16 25)

: (mapcar ** (1 2 3 4 5) (2 .))  # Same, using a circular list
-> (1 4 9 16 25)

: (mapcar if '(T NIL T NIL) '(1 2 3 4) '(5 6 7 8))  # Conditional function
-> (1 6 3 8)

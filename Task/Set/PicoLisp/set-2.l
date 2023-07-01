# Create three test-sets
(balance 'Set1 (1 2 3 7 abc "def" (u v w)))
(balance 'Set2 (2 3 5 hello (x y z)))
(balance 'Set3 (3 hello (x y z)))


# Get contents
: (idx 'Set1)
-> (1 2 3 7 abc "def" (u v w))

: (idx 'Set2)
-> (2 3 5 hello (x y z))


# Element tests (any non-NIL value means "yes")
: (idx 'Set1 "def")
-> ("def" (abc) (u v w))

: (idx 'Set2 "def")
-> NIL

: (idx 'Set2 '(x y z))
-> ((x y z))


# Union
: (use S
   (balance 'S (idx 'Set1))
   (balance 'S (idx 'Set2) T)
   (idx 'S) )
-> (1 2 3 5 7 abc "def" hello (u v w) (x y z))


# Intersection
: (sect (idx 'Set1) (idx 'Set2))
-> (2 3)


# Difference
: (diff (idx 'Set1) (idx 'Set2))
-> (1 7 abc "def" (u v w))


# Test for subset
: (not (diff (idx 'Set1) (idx 'Set2)))
-> NIL  # Set1 is not a subset of Set2

: (not (diff (idx 'Set3) (idx 'Set2)))
-> T  # Set3 is a subset of Set2


# Test for equality
: (= (idx 'Set1) (idx 'Set2))
-> NIL

: (= (idx 'Set2) (idx 'Set2))
-> T

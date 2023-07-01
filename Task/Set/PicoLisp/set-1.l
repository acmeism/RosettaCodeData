(setq
   Set1 (1 2 3 7 abc "def" (u v w))
   Set2 (2 3 5 hello (x y z))
   Set3 (3 hello (x y z)) )


# Element tests (any non-NIL value means "yes")
: (member "def" Set1)
-> ("def" (u v w))

: (member "def" Set2)
-> NIL

: (member '(x y z) Set2)
-> ((x y z))


# Union
: (uniq (append Set1 Set2))
-> (1 2 3 7 abc "def" (u v w) 5 hello (x y z))


# Intersection
: (sect Set1 Set2)
-> (2 3)


# Difference
: (diff Set1 Set2)
-> (1 7 abc "def" (u v w))


# Test for subset
: (not (diff Set1 Set2))
-> NIL  # Set1 is not a subset of Set2

: (not (diff Set3 Set2))
-> T  # Set3 is a subset of Set2


# Test for equality
: (= (sort (copy Set1)) (sort (copy Set2)))
-> NIL

: (= (sort (copy Set2)) (sort (copy Set2)))
-> T

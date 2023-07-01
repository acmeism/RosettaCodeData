# The built-in function "do" can be used to achieve our goal,
# however, it has a slightly different syntax than what the
# problem specifies.

# Native solution.
(do 10 (version))

# Our solution.
(de dofn (Fn N)
   (do N (Fn)) )

(dofn version 10)

⍝ APL has a powerful operator the « dyadic domino » to solve a system of N linear equations with N unknowns
⍝ We use it first to solve the a and b, defining the 2 lines as y = ax + b, with the x and y of the given points
⍝ The system of equations for first line will be:
⍝  0 = 4a + b
⍝ 10 = 6a + b
⍝ The two arguments to be passed to the dyadic domino are:
⍝ The (0, 10) vector as the left argument
⍝ The ( 4  1 ) matrix as the right argument.
⍝     ( 6  1 )
⍝ We will define a solver that will take the matrix of coordinates, one point per row, then massage the argument to extract x,y
⍝ and inject 1, where needed, and return a pair (a, b) of resolved unknowns.
⍝ Applied twice, we will have a, b and a', b' defining the two lines, we need to resolve it in x and y, in order to determine
⍝ their intersection
⍝ y =  ax + b
⍝ y = a'x + b'
⍝ In order to reuse the same solver, we need to format a little bit the arguments, and change the sign of a and a', therefore
⍝ multiply (a,b) and (a', b') by (-1, 1):
⍝ b  =  -ax + y
⍝ b' = -a'x + y
  A ← 4 0
  B ← 6 10
  C ← 0 3
  D ← 10 7
  solver ← {(,2 ¯1↑⍵)⌹(2 1↑⍵),1}
  I ← solver 2 2⍴((¯1 1)×solver 2 2⍴A,B),(¯1 1)×solver 2 2⍴C,D

  A: ?("John";"Bob";"Mary";"Serena")
  B: ?("Jim";"Mary";"John";"Bob")

  A _dvl B               / in A but not in B
"Serena"
  B _dvl A               / in B but not in A
"Jim"
  (A _dvl B;B _dvl A)    / Symmetric difference
("Serena"
 "Jim")

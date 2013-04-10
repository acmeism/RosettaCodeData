(de math (A B)
   (prinl "Add      " (+ A B))
   (prinl "Subtract " (- A B))
   (prinl "Multiply " (* A B))
   (prinl "Divide   " (/ A B))        # Trucates towards zero
   (prinl "Div/rnd  " (*/ A B))       # Rounds to next integer
   (prinl "Modulus  " (% A B))        # Sign of the first operand
   (prinl "Power    " (** A B)) )

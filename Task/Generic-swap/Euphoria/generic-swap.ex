include std/console.e -- for display

object x = 3.14159
object y = "Rosettacode"

{y,x} = {x,y}

display("x is now []",{x})
display("y is now []",{y})

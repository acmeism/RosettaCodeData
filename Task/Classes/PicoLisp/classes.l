(class +Rectangle)
# dx dy

(dm area> ()  # Define a a method that calculates the rectangle's area
   (* (: dx) (: dy)) )

(println  # Create a rectangle, and print its area
   (area> (new '(+Rectangle) 'dx 3 'dy 4)) )

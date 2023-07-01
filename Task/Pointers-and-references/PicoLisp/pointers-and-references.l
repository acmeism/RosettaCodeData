: (setq L (1 a 2 b 3 c))         # Create a list of 6 items in 'L'
-> (1 a 2 b 3 c)

: (nth L 4)                      # Get a pointer to the 4th item
-> (b 3 c)

: (set (nth L 4) "Hello")        # Store "Hello" in that location
-> "Hello"

: L                              # Look at the modified list in 'L'
-> (1 a 2 "Hello" 3 c)

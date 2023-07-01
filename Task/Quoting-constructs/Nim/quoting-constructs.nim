echo "A simple string."
echo "A simple string including tabulation special character \\t: \t."

echo """
First part of a multiple string,
followed by second part
and third part.
"""

echo r"A raw string containing a \."

# Interpolation in strings.
import strformat
const C = "constant"
const S = fmt"A string with interpolation of a {C}."
echo S
var x = 3
echo fmt"A string with interpolation of expression “2 * x + 3”: {2 * x + 3}."
echo fmt"Displaying “x” with an embedded format: {x:05}."

# Regular expression string.
import re
let r = re"\d+"

# Pegs string.
import pegs
let e = peg"\d+"

# Array literal.
echo [1, 2, 3]        # Element type if implicit ("int" here).
echo [byte(1), 2, 3]  # Element type is specified by the first element type.
echo [byte 1, 2, 3]   # An equivalent way to specify the type.

echo @[1, 2, 3]       # Sequence of ints.

# Tuples.
echo ('a', 1, true)   # Tuple without explicit field names.
echo (x: 1, y: 2)     # Tuple with two int fields "x" and "y".

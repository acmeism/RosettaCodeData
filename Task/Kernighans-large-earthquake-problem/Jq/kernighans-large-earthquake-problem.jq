input as $one
| "The earthquakes from \(input_filename) with a magnitude greater than 6 are:\n",
( $one, inputs
  | . as $line
  | [splits("  *")]
  | if length < 3
    then "WARNING: invalid line:\n\($line)"
    else try ((.[2] | tonumber) as $mag
    | select($mag > 6)
    | $line) catch "WARNING: column 3 is not a recognized number in the line:\n\($line)"
    end )

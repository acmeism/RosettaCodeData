{i:42, count:0}
| while( .count <= 42;
    .emit = null
    | .i += 1
    | if .i|is_prime
      then
      .count += 1
      | .emit = "count at \(.i) is \(.count)"
      | .i = .i + .i - 1
      else .
      end )
| select(.emit).emit

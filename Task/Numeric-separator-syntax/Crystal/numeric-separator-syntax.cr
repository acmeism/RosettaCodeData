icr:1> 1111111 # no underscores
 => 1111111
icr:2> 1_11_1_111 # underscores between digits
 => 1111111
icr:3> 1111111u64 # no underscore between number and type suffix
 => 1111111
icr:4> 1111111_u64 # underscore between number and type suffix
 => 1111111
icr:5> 1111__111
syntax error in :1
Error: consecutive underscores in numbers aren't allowed
icr:6> 1111111_
syntax error in :1
Error: trailing '_' in number
icr:7> _1111111
error in line 1
Error: undefined local variable or method '_1111111' for top-level

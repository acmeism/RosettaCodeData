set op [[NG2 new 0 1 1 0 0 0 0 1] operands [R2CF new 1/2] [R2CF new 22/7]]
printcf "\[3;7\] + \[0;2\]" $op

set op [[NG2 new 1 0 0 0 0 0 0 1] operands [R2CF new 13/11] [R2CF new 22/7]]
printcf "\[1:5,2\] * \[3;7\]" $op

set op [[NG2 new 0 1 -1 0 0 0 0 1] operands [R2CF new 13/11] [R2CF new 22/7]]
printcf "\[1:5,2\] - \[3;7\]" $op

set op [[NG2 new 0 1 0 0 0 0 1 0] operands [R2CF new 484/49] [R2CF new 22/7]]
printcf "div test" $op

set op1 [[NG2 new 0 1 1 0 0 0 0 1] operands [R2CF new 2/7] [R2CF new 13/11]]
set op2 [[NG2 new 0 1 -1 0 0 0 0 1] operands [R2CF new 2/7] [R2CF new 13/11]]
set op3 [[NG2 new 1 0 0 0 0 0 0 1] operands $op1 $op2]
printcf "layered test" $op3

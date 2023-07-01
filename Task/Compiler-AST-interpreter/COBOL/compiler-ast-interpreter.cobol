        >>SOURCE FORMAT IS FREE
identification division.
*> this code is dedicated to the public domain
*> (GnuCOBOL) 2.3-dev.0
program-id. astinterpreter.
environment division.
configuration section.
repository. function all intrinsic.
data division.
working-storage section.
01  program-name pic x(32) value spaces global.
01  input-name pic x(32) value spaces global.
01  input-status pic xx global.

01  ast-record global.
    03  ast-type pic x(14).
    03  ast-value pic x(48).
    03  filler redefines ast-value.
        05  asl-left pic 999.
        05  asl-right pic 999.

01  error-record pic x(64) value spaces global.

01  loadstack global.
    03  l pic 99 value 0.
    03  l-lim pic 99 value 64.
    03  load-entry occurs 64.
        05  l-node pic x(14).
        05  l-left pic 999.
        05  l-right pic 999.
        05  l-link pic 999.

01  abstract-syntax-tree global.
    03  t pic 999 value 0.
    03  t1 pic 999.
    03  n1 pic 999.
    03  t-lim pic 999 value 998.
    03  filler occurs 998.
        05  leaf.
            07  leaf-type pic x(14).
            07  leaf-value pic x(48).
        05  node redefines leaf.
            07  node-type pic x(14).
            07  node-left pic 999.
            07  node-right pic 999.


01  interpreterstack global.
    03  stack1 pic 99 value 2.
    03  stack2 pic 99 value 1.
    03  stack-lim pic 99 value 32.
    03  stack-entry occurs 32.
         05  stack-source pic 99.
         05  stack usage binary-int.

01  variables global.
    03  v pic 99.
    03  v-max pic 99 value 0.
    03  v-lim pic 99 value 16.
    03  filler occurs 16.
        05  variable-value binary-int.
        05  variable-name pic x(48).

01  strings global.
    03  s pic 99.
    03  s-max pic 99 value 0.
    03  s-lim pic 99 value 16.
    03  filler occurs 16 value spaces.
        05  string-value pic x(48).

01  string-fields global.
    03  string-length pic 99.
    03  string1 pic 99.
    03  length1 pic 99.
    03  count1 pic 99.

01  display-fields global.
    03  display-number pic -(9)9.
    03  display-pending pic x value 'n'.
    03  character-value.
        05  character-number usage binary-char.

procedure division chaining program-name.
start-astinterpreter.
    call 'loadast'
    if program-name <> spaces
        call 'readinput' *> close the input-file
    end-if
    >>d perform print-ast
    call 'runast' using t
    if display-pending = 'y'
        display space
    end-if
    stop run
    .
print-ast.
    call 'printast' using t
    display 'ast:' upon syserr
    display 't=' t
    perform varying t1 from 1 by 1 until t1 > t
        if leaf-type(t1) = 'Identifier' or 'Integer' or 'String'
            display t1 space trim(leaf-type(t1)) space trim(leaf-value(t1)) upon syserr
        else
            display t1 space node-left(t1) space node-right(t1) space trim(node-type(t1))
                upon syserr
        end-if
    end-perform
    .

identification division.
program-id. runast common recursive.
data division.
working-storage section.
01  word-length constant as length of binary-int.
linkage section.
01  n pic 999.
procedure division using n.
start-runast.
    if n = 0
        exit program
    end-if
    evaluate node-type(n)
    when 'Integer'
        perform push-stack
        move numval(leaf-value(n)) to stack(stack1)
    when 'Identifier'
        perform get-variable-index
        perform push-stack
        move v to stack-source(stack1)
        move variable-value(v) to stack(stack1)
    when 'String'
        perform get-string-index
        perform push-stack
        move s to stack-source(stack1)
    when 'Assign'
        call 'runast' using node-left(n)
        call 'runast' using node-right(n)
        move stack-source(stack2) to v
        move stack(stack1) to variable-value(v)
        perform pop-stack
        perform pop-stack
    when 'If'
        call 'runast' using node-left(n)
        move node-right(n) to n1
        if stack(stack1) <> 0
            call 'runast' using node-left(n1)
        else
            call 'runast' using node-right(n1)
        end-if
        perform pop-stack
    when 'While'
        call 'runast' using node-left(n)
        perform until stack(stack1) = 0
            perform pop-stack
            call 'runast' using node-right(n)
            call 'runast' using node-left(n)
        end-perform
        perform pop-stack
    when 'Add'
        perform get-values
        add stack(stack1) to stack(stack2)
        perform pop-stack
    when 'Subtract'
        perform get-values
        subtract stack(stack1) from stack(stack2)
        perform pop-stack
    when 'Multiply'
        perform get-values
        multiply stack(stack1) by stack(stack2)
        perform pop-stack
    when 'Divide'
        perform get-values
        divide stack(stack1) into stack(stack2)
        perform pop-stack
    when 'Mod'
        perform get-values
        move mod(stack(stack2),stack(stack1)) to stack(stack2)
        perform pop-stack
    when 'Less'
        perform get-values
        if stack(stack2) < stack(stack1)
            move 1 to stack(stack2)
        else
            move 0 to stack(stack2)
        end-if
        perform pop-stack
    when 'Greater'
        perform get-values
        if stack(stack2) > stack(stack1)
            move 1 to stack(stack2)
        else
            move 0 to stack(stack2)
        end-if
        perform pop-stack
    when 'LessEqual'
        perform get-values
        if stack(stack2) <= stack(stack1)
            move 1 to stack(stack2)
        else
            move 0 to stack(stack2)
        end-if
        perform pop-stack
    when 'GreaterEqual'
        perform get-values
        if stack(stack2) >= stack(stack1)
            move 1 to stack(stack2)
        else
            move 0 to stack(stack2)
        end-if
        perform pop-stack
    when 'Equal'
        perform get-values
        if stack(stack2) = stack(stack1)
            move 1 to stack(stack2)
        else
            move 0 to stack(stack2)
        end-if
        perform pop-stack
    when 'NotEqual'
        perform get-values
        if stack(stack2) <> stack(stack1)
            move 1 to stack(stack2)
        else
            move 0 to stack(stack2)
        end-if
        perform pop-stack
    when 'And'
        perform get-values
        call "CBL_AND" using stack(stack1) stack(stack2) by value word-length
        perform pop-stack
    when 'Or'
        perform get-values
        call "CBL_OR" using stack(stack1) stack(stack2) by value word-length
        perform pop-stack
    when 'Not'
        call 'runast' using node-left(n)
        if stack(stack1) = 0
            move 1 to stack(stack1)
        else
            move 0 to stack(stack1)
        end-if
    when 'Negate'
        call 'runast' using node-left(n)
        compute stack(stack1) = - stack(stack1)
    when 'Prtc'
        call 'runast' using node-left(n)
        move stack(stack1) to character-number
        display character-value with no advancing
        move 'y' to display-pending
        perform pop-stack
    when 'Prti'
        call 'runast' using node-left(n)
        move stack(stack1) to display-number
        display trim(display-number) with no advancing
        move 'y' to display-pending
        perform pop-stack
    when 'Prts'
        call 'runast' using node-left(n)
        move stack-source(stack1) to s
        move length(trim(string-value(s))) to string-length
        move 2 to string1
        compute length1 = string-length - 2
        perform until string1 >= string-length
            move 0 to count1
            inspect string-value(s)(string1:length1)
                tallying count1 for characters before initial '\'   *> ' (workaround Rosetta Code highlighter problem)
            evaluate true
            when string-value(s)(string1 + count1 + 1:1) = 'n' *> \n
                display string-value(s)(string1:count1)
                move 'n' to display-pending
                compute string1 = string1 + 2 + count1
                compute length1 = length1 - 2 - count1
            when string-value(s)(string1 + count1 + 1:1) = '\' *> \\ '
                display string-value(s)(string1:count1 + 1) with no advancing
                move 'y' to display-pending
                compute string1 = string1 + 2 + count1
                compute length1 = length1 - 2 - count1
            when other
                display string-value(s)(string1:count1) with no advancing
                move 'y' to display-pending
                add count1 to string1
                subtract count1 from length1
            end-evaluate
        end-perform
        perform pop-stack
    when 'Sequence'
        call 'runast' using node-left(n)
        call 'runast' using node-right(n)
    when other
        string 'in astinterpreter unknown node type ' node-type(n) into error-record
        call 'reporterror'
    end-evaluate
    exit program
    .
push-stack.
    if stack1 >= s-lim
        string 'in astinterpreter at ' n ' stack overflow' into error-record
        call 'reporterror'
    end-if
    add 1 to stack1 stack2
    initialize stack-entry(stack1)
    .
pop-stack.
    if stack1 < 2
        string 'in astinterpreter at ' n ' stack underflow ' into error-record
        call 'reporterror'
    end-if
    subtract 1 from stack1 stack2
    .
get-variable-index.
    perform varying v from 1 by 1 until v > v-max
    or variable-name(v) = leaf-value(n)
        continue
    end-perform
    if v > v-max
        if v-max = v-lim
            string 'in astinterpreter number of variables exceeds ' v-lim into error-record
            call 'reporterror'
        end-if
        move v to v-max
        move leaf-value(n) to variable-name(v)
        move 0 to variable-value(v)
    end-if
    .
get-string-index.
    perform varying s from 1 by 1 until s > s-max
    or string-value(s) = leaf-value(n)
        continue
    end-perform
    if s > s-max
        if s-max = s-lim
            string 'in astinterpreter number of strings exceeds ' s-lim into error-record
            call 'reporterror'
        end-if
        move s to s-max
        move leaf-value(n) to string-value(s)
    end-if
    .
get-values.
    call 'runast' using node-left(n)
    call 'runast' using node-right(n)
    .
end program runast.

identification division.
program-id. loadast common recursive.
procedure division.
start-loadast.
    if l >= l-lim
        string 'in astinterpreter loadast l exceeds ' l-lim into error-record
        call 'reporterror'
    end-if
    add 1 to l
    call 'readinput'
    evaluate true
    when ast-record = ';'
    when input-status = '10'
        move 0 to return-code
    when ast-type = 'Identifier'
    when ast-type = 'Integer'
    when ast-type = 'String'
        call 'makeleaf' using ast-type ast-value
        move t to return-code
    when ast-type = 'Sequence'
        move ast-type to l-node(l)
        call 'loadast'
        move return-code to l-left(l)
        call 'loadast'
        move t to l-right(l)
        call 'makenode' using l-node(l) l-left(l) l-right(l)
        move t to return-code
    when other
        move ast-type to l-node(l)
        call 'loadast'
        move return-code to l-left(l)
        call 'loadast'
        move return-code to l-right(l)
        call 'makenode' using l-node(l) l-left(l) l-right(l)
        move t to return-code
    end-evaluate
    subtract 1 from l
    .
end program loadast.

identification division.
program-id. makenode common.
data division.
linkage section.
01  parm-type any length.
01  parm-l-left pic 999.
01  parm-l-right pic 999.
procedure division using parm-type parm-l-left parm-l-right.
start-makenode.
    if t >= t-lim
        string 'in astinterpreter makenode t exceeds ' t-lim into error-record
        call 'reporterror'
    end-if
    add 1 to t
    move parm-type to node-type(t)
    move parm-l-left to node-left(t)
    move parm-l-right to node-right(t)
    .
end program makenode.

identification division.
program-id. makeleaf common.
data division.
linkage section.
01  parm-type any length.
01  parm-value pic x(48).
procedure division using parm-type parm-value.
start-makeleaf.
    add 1 to t
    if t >= t-lim
        string 'in astinterpreter makeleaf t exceeds ' t-lim into error-record
        call 'reporterror'
    end-if
    move parm-type to leaf-type(t)
    move parm-value to leaf-value(t)
    .
end program makeleaf.

identification division.
program-id. printast common recursive.
data division.
linkage section.
01  n pic 999.
procedure division using n.
start-printast.
    if n = 0
        display ';' upon syserr
        exit program
    end-if
    display leaf-type(n) upon syserr
    evaluate leaf-type(n)
    when 'Identifier'
    when 'Integer'
    when 'String'
        display leaf-type(n) space trim(leaf-value(n)) upon syserr
    when other
        display node-type(n) upon syserr
        call 'printast' using node-left(n)
        call 'printast' using node-right(n)
    end-evaluate
    .
end program printast.

identification division.
program-id. readinput common.
environment division.
input-output section.
file-control.
    select input-file assign using input-name
        status is input-status
        organization is line sequential.
data division.
file section.
fd  input-file.
01  input-record pic x(64).
procedure division.
start-readinput.
    if program-name = spaces
        move '00' to input-status
        accept ast-record on exception move '10' to input-status end-accept
        exit program
    end-if
    if input-name = spaces
        string program-name delimited by space '.ast' into input-name
        open input input-file
        if input-status = '35'
            string 'in astinterpreter ' trim(input-name) ' not found' into error-record
            call 'reporterror'
        end-if
    end-if
    read input-file into ast-record
    evaluate input-status
    when '00'
        continue
    when '10'
        close input-file
    when other
        string 'in astinterpreter ' trim(input-name) ' unexpected input-status: ' input-status
            into error-record
        call 'reporterror'
    end-evaluate
    .
end program readinput.

program-id. reporterror common.
procedure division.
start-reporterror.
report-error.
    display error-record upon syserr
    stop run with error status -1
    .
end program reporterror.
end program astinterpreter.
